// Tests for [AuthCubit]'s biometric restore pipeline.
//
// This file covers two task-list items from
// `.kiro/specs/app-flow-adjustments/tasks.md`:
//
//   * Property 5 (task 5.7): Biometric restore performs autofill and
//     invokes the standard login use case.
//     **Validates: Requirements 3.5, 3.8**
//
//   * Bloc test (task 5.9): `AuthCubit` biometric status state machine —
//     unavailable, not-enabled, ready+success, ready+restore-failure,
//     ready+session-expired transitions.
//     **Validates: Requirements 3.2, 3.3, 3.6, 3.7**
//
// Test strategy
// -------------
// `AuthCubit` depends on nine collaborators. We mock all of them with
// `mocktail`; the cubit itself is exercised end-to-end so that the
// real `requestBiometricLogin` orchestration logic runs.
//
// Glados drives variation of the `(phoneNumber, password)` tuple for
// Property 5 with at least 100 iterations. Each iteration constructs a
// fresh cubit so the autofill broadcast stream and verify counts are
// hermetic per case.
//
// Import note: glados re-exports `package:test_core/scaffolding.dart`,
// which collides with `flutter_test`'s `setUpAll`/`group`/`test`/`expect`.
// We keep the `flutter_test` versions and hide the duplicates from glados.
// Mocktail's `any` also collides with glados's `any` extension receiver,
// so mocktail is imported under the `mt` prefix.

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart'
    hide expect, group, test, setUpAll, setUp, tearDown, tearDownAll;
import 'package:mocktail/mocktail.dart' as mt;
import 'package:teman_lansia/core/constants/pref_keys.dart';
import 'package:teman_lansia/core/errors/failures.dart';
import 'package:teman_lansia/core/usecases/use_case.dart';
import 'package:teman_lansia/features/auth/domain/repositories/biometric_credential_repository.dart';
import 'package:teman_lansia/features/auth/domain/usecases/check_biometric_availability_use_case.dart';
import 'package:teman_lansia/features/auth/domain/usecases/clear_biometric_credentials_use_case.dart';
import 'package:teman_lansia/features/auth/domain/usecases/create_guest_session_use_case.dart';
import 'package:teman_lansia/features/auth/domain/usecases/get_session_use_case.dart';
import 'package:teman_lansia/features/auth/domain/usecases/login_use_case.dart';
import 'package:teman_lansia/features/auth/domain/usecases/logout_use_case.dart';
import 'package:teman_lansia/features/auth/domain/usecases/register_use_case.dart';
import 'package:teman_lansia/features/auth/domain/usecases/restore_biometric_credentials_use_case.dart';
import 'package:teman_lansia/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:teman_lansia/features/auth/presentation/cubit/auth_state.dart';
import 'package:teman_lansia/shared/data/datasources/shared_preferences_data_source.dart';
import 'package:teman_lansia/shared/domain/entities/user_entity.dart';
import 'package:teman_lansia/shared/domain/enums/app_enums.dart';

// ── Mocks ────────────────────────────────────────────────────────────────────

class _MockLoginUseCase extends mt.Mock implements LoginUseCase {}

class _MockRegisterUseCase extends mt.Mock implements RegisterUseCase {}

class _MockLogoutUseCase extends mt.Mock implements LogoutUseCase {}

class _MockGetSessionUseCase extends mt.Mock implements GetSessionUseCase {}

class _MockCreateGuestSessionUseCase extends mt.Mock
    implements CreateGuestSessionUseCase {}

class _MockPrefsDataSource extends mt.Mock
    implements SharedPreferencesDataSource {}

class _MockCheckBiometricUseCase extends mt.Mock
    implements CheckBiometricAvailabilityUseCase {}

class _MockRestoreBiometricUseCase extends mt.Mock
    implements RestoreBiometricCredentialsUseCase {}

class _MockClearBiometricUseCase extends mt.Mock
    implements ClearBiometricCredentialsUseCase {}

// ── Fixture ──────────────────────────────────────────────────────────────────

const _testReason = 'test reason';

UserEntity _buildUser({String id = 'user-1', String phone = '+6281234567890'}) {
  return UserEntity(
    id: id,
    name: 'Tester',
    phoneNumber: phone,
    age: 65,
    gender: 'male',
    programLevel: ProgramLevel.beginner,
    healthConditions: const [],
    emergencyContacts: const [],
  );
}

class _Fixture {
  final _MockLoginUseCase login;
  final _MockRegisterUseCase register;
  final _MockLogoutUseCase logout;
  final _MockGetSessionUseCase getSession;
  final _MockCreateGuestSessionUseCase createGuest;
  final _MockPrefsDataSource prefs;
  final _MockCheckBiometricUseCase checkBiometric;
  final _MockRestoreBiometricUseCase restoreBiometric;
  final _MockClearBiometricUseCase clearBiometric;
  final AuthCubit cubit;

  _Fixture._(
    this.login,
    this.register,
    this.logout,
    this.getSession,
    this.createGuest,
    this.prefs,
    this.checkBiometric,
    this.restoreBiometric,
    this.clearBiometric,
    this.cubit,
  );

  factory _Fixture.create() {
    final login = _MockLoginUseCase();
    final register = _MockRegisterUseCase();
    final logout = _MockLogoutUseCase();
    final getSession = _MockGetSessionUseCase();
    final createGuest = _MockCreateGuestSessionUseCase();
    final prefs = _MockPrefsDataSource();
    final checkBiometric = _MockCheckBiometricUseCase();
    final restoreBiometric = _MockRestoreBiometricUseCase();
    final clearBiometric = _MockClearBiometricUseCase();

    // SharedPreferences default: no flags set.
    mt.when(() => prefs.getBool(mt.any())).thenReturn(null);

    final cubit = AuthCubit(
      login,
      register,
      logout,
      getSession,
      createGuest,
      prefs,
      checkBiometric,
      restoreBiometric,
      clearBiometric,
    );

    return _Fixture._(
      login,
      register,
      logout,
      getSession,
      createGuest,
      prefs,
      checkBiometric,
      restoreBiometric,
      clearBiometric,
      cubit,
    );
  }
}

// ── Glados generators ────────────────────────────────────────────────────────

const _phoneDigits = '0123456789';
const _passwordChars =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';

typedef _PhoneAndPassword = ({String phoneNumber, String password});

extension _AuthCubitAnys on Any {
  /// Strings drawn from [alphabet] with length in `[min, max)`.
  Generator<String> stringOfRange(String alphabet, int min, int max) =>
      listWithLengthInRange(min, max, choose(alphabet.split('')))
          .map((chars) => chars.join());

  /// `'+' + 8-15 digits` — a normalized E.164 phone number.
  Generator<String> get e164 =>
      listWithLengthInRange(8, 16, choose(_phoneDigits.split('')))
          .map((d) => '+${d.join()}');

  /// `(phoneNumber, password)` — any valid restored credential pair.
  Generator<_PhoneAndPassword> get phoneAndPassword => combine2(
        e164,
        stringOfRange(_passwordChars, 1, 33),
        (String phone, String password) =>
            (phoneNumber: phone, password: password),
      );
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() {
    mt.registerFallbackValue(const NoParams());
    mt.registerFallbackValue(
      const LoginParams(phoneNumber: '_fallback', password: '_fallback'),
    );
    mt.registerFallbackValue(
      const RestoreBiometricCredentialsParams(reason: '_fallback'),
    );
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Property 5 (task 5.7): Biometric restore performs autofill and invokes
  // the standard login use case.
  // **Validates: Requirements 3.5, 3.8**
  // ───────────────────────────────────────────────────────────────────────────
  group(
      'Property 5: Biometric restore performs autofill and invokes the '
      'standard login use case', () {
    Glados<_PhoneAndPassword>(any.phoneAndPassword).test(
      'autofillStream emits exactly the restored pair and LoginUseCase is '
      'invoked once with those same values',
      (creds) async {
        final fx = _Fixture.create();

        // Stub: device is ready, restore returns the generated tuple,
        // LoginUseCase succeeds with a deterministic user.
        mt.when(() => fx.checkBiometric(const NoParams())).thenAnswer(
          (_) async => const Right(BiometricStatus.ready),
        );
        mt
            .when(() => fx.restoreBiometric(mt.any()))
            .thenAnswer((_) async => Right(creds));
        final user = _buildUser();
        mt
            .when(() => fx.login(mt.any()))
            .thenAnswer((_) async => Right(user));

        // Subscribe BEFORE the call so the broadcast stream delivers the
        // event we are about to publish.
        final received = <_PhoneAndPassword>[];
        final sub = fx.cubit.autofillStream.listen(received.add);

        await fx.cubit.requestBiometricLogin(reason: _testReason);

        // Allow stream events to drain on the microtask queue.
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        // R3.5 — autofill must fire exactly once with the restored tuple.
        expect(
          received,
          hasLength(1),
          reason: 'autofillStream must emit exactly one event per '
              'biometric restore; got ${received.length}',
        );
        expect(received.single.phoneNumber, equals(creds.phoneNumber));
        expect(received.single.password, equals(creds.password));

        // R3.8 — LoginUseCase must be invoked with those autofilled
        // values, not synthesized credentials.
        final captured =
            mt.verify(() => fx.login(mt.captureAny())).captured;
        expect(captured, hasLength(1));
        final params = captured.single as LoginParams;
        expect(params.phoneNumber, equals(creds.phoneNumber));
        expect(params.password, equals(creds.password));

        await fx.cubit.close();
      },
    );
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Bloc test (task 5.9): AuthCubit biometric status state machine.
  // **Validates: Requirements 3.2, 3.3, 3.6, 3.7**
  // ───────────────────────────────────────────────────────────────────────────
  group('AuthCubit biometric status state machine', () {
    late _Fixture fx;
    final user = _buildUser();
    final restoredCreds = (
      phoneNumber: user.phoneNumber,
      password: 'correct-horse-battery-staple',
    );

    setUp(() {
      fx = _Fixture.create();
    });

    blocTest<AuthCubit, AuthState>(
      'emits [AuthBiometricUnavailable] when status is unavailable; never '
      'invokes restore or login (R3.2)',
      setUp: () {
        mt.when(() => fx.checkBiometric(const NoParams())).thenAnswer(
          (_) async => const Right(BiometricStatus.unavailable),
        );
      },
      build: () => fx.cubit,
      act: (cubit) => cubit.requestBiometricLogin(reason: _testReason),
      expect: () => const <AuthState>[AuthBiometricUnavailable()],
      verify: (_) {
        mt.verifyNever(() => fx.restoreBiometric(mt.any()));
        mt.verifyNever(() => fx.login(mt.any()));
        mt.verifyNever(() => fx.clearBiometric(const NoParams()));
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthBiometricNotEnabled] when status is disabled; never '
      'invokes restore or login (R3.3)',
      setUp: () {
        mt.when(() => fx.checkBiometric(const NoParams())).thenAnswer(
          (_) async => const Right(BiometricStatus.disabled),
        );
      },
      build: () => fx.cubit,
      act: (cubit) => cubit.requestBiometricLogin(reason: _testReason),
      expect: () => const <AuthState>[AuthBiometricNotEnabled()],
      verify: (_) {
        mt.verifyNever(() => fx.restoreBiometric(mt.any()));
        mt.verifyNever(() => fx.login(mt.any()));
        mt.verifyNever(() => fx.clearBiometric(const NoParams()));
      },
    );

    blocTest<AuthCubit, AuthState>(
      'ready + restore success + login success (onboarding done) emits '
      '[AuthBiometricRestoring, AuthAuthenticated]',
      setUp: () {
        mt.when(() => fx.checkBiometric(const NoParams())).thenAnswer(
          (_) async => const Right(BiometricStatus.ready),
        );
        mt.when(() => fx.restoreBiometric(mt.any())).thenAnswer(
          (_) async => Right(restoredCreds),
        );
        mt.when(() => fx.login(mt.any())).thenAnswer(
          (_) async => Right(user),
        );
        mt
            .when(() => fx.prefs.getBool(PrefKeys.onboardingComplete))
            .thenReturn(true);
      },
      build: () => fx.cubit,
      act: (cubit) => cubit.requestBiometricLogin(reason: _testReason),
      expect: () => <AuthState>[
        const AuthBiometricRestoring(),
        AuthAuthenticated(user),
      ],
      verify: (_) {
        mt.verifyNever(() => fx.clearBiometric(const NoParams()));
      },
    );

    blocTest<AuthCubit, AuthState>(
      'ready + restore success + login success (onboarding NOT done) emits '
      '[AuthBiometricRestoring, AuthNeedsOnboarding]',
      setUp: () {
        mt.when(() => fx.checkBiometric(const NoParams())).thenAnswer(
          (_) async => const Right(BiometricStatus.ready),
        );
        mt.when(() => fx.restoreBiometric(mt.any())).thenAnswer(
          (_) async => Right(restoredCreds),
        );
        mt.when(() => fx.login(mt.any())).thenAnswer(
          (_) async => Right(user),
        );
        mt
            .when(() => fx.prefs.getBool(PrefKeys.onboardingComplete))
            .thenReturn(false);
      },
      build: () => fx.cubit,
      act: (cubit) => cubit.requestBiometricLogin(reason: _testReason),
      expect: () => <AuthState>[
        const AuthBiometricRestoring(),
        AuthNeedsOnboarding(user),
      ],
      verify: (_) {
        mt.verifyNever(() => fx.clearBiometric(const NoParams()));
      },
    );

    blocTest<AuthCubit, AuthState>(
      'ready + restore failure (e.g. user cancelled) emits '
      '[AuthBiometricRestoring, AuthBiometricFailed]; clearBiometric is '
      'NOT invoked (R3.6)',
      setUp: () {
        mt.when(() => fx.checkBiometric(const NoParams())).thenAnswer(
          (_) async => const Right(BiometricStatus.ready),
        );
        mt.when(() => fx.restoreBiometric(mt.any())).thenAnswer(
          (_) async => const Left(
            Failure.unexpected(message: 'authBiometricFailed'),
          ),
        );
      },
      build: () => fx.cubit,
      act: (cubit) => cubit.requestBiometricLogin(reason: _testReason),
      expect: () => const <AuthState>[
        AuthBiometricRestoring(),
        AuthBiometricFailed('authBiometricFailed'),
      ],
      verify: (_) {
        mt.verifyNever(() => fx.login(mt.any()));
        mt.verifyNever(() => fx.clearBiometric(const NoParams()));
      },
    );

    blocTest<AuthCubit, AuthState>(
      'ready + restore success + login failure emits '
      '[AuthBiometricRestoring, AuthError(authBiometricSessionExpired)]; '
      'clearBiometric IS invoked exactly once (R3.7)',
      setUp: () {
        mt.when(() => fx.checkBiometric(const NoParams())).thenAnswer(
          (_) async => const Right(BiometricStatus.ready),
        );
        mt.when(() => fx.restoreBiometric(mt.any())).thenAnswer(
          (_) async => Right(restoredCreds),
        );
        mt.when(() => fx.login(mt.any())).thenAnswer(
          (_) async => const Left(
            Failure.cache(message: 'authInvalidCredentials'),
          ),
        );
        mt.when(() => fx.clearBiometric(const NoParams())).thenAnswer(
          (_) async => const Right(unit),
        );
      },
      build: () => fx.cubit,
      act: (cubit) => cubit.requestBiometricLogin(reason: _testReason),
      expect: () => const <AuthState>[
        AuthBiometricRestoring(),
        AuthError('authBiometricSessionExpired'),
      ],
      verify: (_) {
        mt.verify(() => fx.clearBiometric(const NoParams())).called(1);
      },
    );
  });
}
