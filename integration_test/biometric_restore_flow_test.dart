// Integration test for the biometric restore flow.
//
// Task 16.3 (`.kiro/specs/app-flow-adjustments/tasks.md`):
//   Login with phone → enable biometric → re-login via biometric restore.
//
// **Validates: Requirements 1.1, 1.4, 3.5, 4.3, 4.4.**
//
// Scope (simplified per task description)
// ---------------------------------------
// `local_auth` and `flutter_secure_storage` cannot run on the integration
// test runner without real platform support, and the project's full DI
// graph (Hive, notifications, timezone, …) is heavy to bootstrap inside
// `integration_test` for a single behaviour. This test therefore takes
// the explicitly authorised "simpler" route from the task plan:
//
//   * Pump just [LoginPage] inside a `MaterialApp` with the localization
//     delegates and an [AppCubit] (used by the page's
//     `LanguageSelectorButton`).
//   * Provide a real [AuthCubit] wired to in-memory fakes:
//       - [_FakeAuthRepository]               — keeps a `Map<String, _UserRecord>`.
//       - [_FakeBiometricCredentialRepository] — in-memory secure storage,
//                                                hardware always "ready",
//                                                OS prompt always succeeds.
//       - [_FakeSharedPreferencesDataSource]   — in-memory `Map<String, Object>`.
//   * Drive the page's controllers and tap targets to exercise the full
//     restore code path end-to-end:
//       1. Type phone + password → tap "Log In" → expect [AuthAuthenticated]
//          (or [AuthNeedsOnboarding]) and the captured user record.
//       2. Simulate "enable biometric" by storing credentials through the
//          repository (we don't pump the Settings page — its widget tests
//          already cover the toggle in isolation).
//       3. Logout via `AuthCubit.logout()`.
//       4. Tap the biometric icon → expect the stream-driven autofill to
//          populate both controllers and the cubit to reach
//          [AuthAuthenticated] / [AuthNeedsOnboarding] without further
//          user interaction (R3.5).
//
// The flow exercises the same orchestration code an end-user would hit on
// device; only the OS prompt and the secure-storage backend are faked.

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:laman_lansia/app/cubit/app_cubit.dart';
import 'package:laman_lansia/core/constants/pref_keys.dart';
import 'package:laman_lansia/core/errors/failures.dart';
import 'package:laman_lansia/di/injection.dart';
import 'package:laman_lansia/features/auth/domain/repositories/auth_repository.dart';
import 'package:laman_lansia/features/auth/domain/repositories/biometric_credential_repository.dart';
import 'package:laman_lansia/features/auth/domain/usecases/check_biometric_availability_use_case.dart';
import 'package:laman_lansia/features/auth/domain/usecases/clear_biometric_credentials_use_case.dart';
import 'package:laman_lansia/features/auth/domain/usecases/create_guest_session_use_case.dart';
import 'package:laman_lansia/features/auth/domain/usecases/get_session_use_case.dart';
import 'package:laman_lansia/features/auth/domain/usecases/login_use_case.dart';
import 'package:laman_lansia/features/auth/domain/usecases/logout_use_case.dart';
import 'package:laman_lansia/features/auth/domain/usecases/register_use_case.dart';
import 'package:laman_lansia/features/auth/domain/usecases/restore_biometric_credentials_use_case.dart';
import 'package:laman_lansia/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:laman_lansia/features/auth/presentation/cubit/auth_state.dart';
import 'package:laman_lansia/features/auth/presentation/pages/login_page.dart';
import 'package:laman_lansia/l10n/app_localizations.dart';
import 'package:laman_lansia/shared/data/datasources/shared_preferences_data_source.dart';
import 'package:laman_lansia/shared/domain/entities/user_entity.dart';
import 'package:laman_lansia/shared/domain/enums/app_enums.dart';

// ── Fakes ────────────────────────────────────────────────────────────────────

class _UserRecord {
  _UserRecord({required this.user, required this.password});
  UserEntity user;
  String password;
}

/// In-memory [AuthRepository] backed by a phone-keyed map. Treats any
/// password as valid for a matching phone to mirror the offline-first
/// `AuthRepositoryImpl` behaviour. Tracks the active session in [_session]
/// so `getSession()` returns the same user [login] just authenticated.
class _FakeAuthRepository implements AuthRepository {
  final Map<String, _UserRecord> _byPhone = <String, _UserRecord>{};
  UserEntity? _session;

  void seed({required UserEntity user, required String password}) {
    _byPhone[user.phoneNumber] = _UserRecord(user: user, password: password);
  }

  @override
  Future<Either<Failure, UserEntity>> login(
    String phoneNumber,
    String password,
  ) async {
    final record = _byPhone[phoneNumber];
    if (record == null) {
      return const Left(Failure.cache(message: 'authInvalidCredentials'));
    }
    _session = record.user;
    return Right(record.user);
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String phoneNumber,
    required String password,
  }) async {
    if (_byPhone.containsKey(phoneNumber)) {
      return const Left(
        Failure.validation(
          field: 'phoneNumber',
          message: 'authPhoneAlreadyTaken',
        ),
      );
    }
    final user = UserEntity(
      id: 'user_${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      phoneNumber: phoneNumber,
      age: 0,
      gender: '',
      programLevel: ProgramLevel.beginner,
      healthConditions: const [],
      emergencyContacts: const [],
    );
    _byPhone[phoneNumber] = _UserRecord(user: user, password: password);
    return Right(user);
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    _session = null;
    return const Right(unit);
  }

  @override
  Future<Either<Failure, UserEntity?>> getSession() async => Right(_session);

  @override
  Future<Either<Failure, Unit>> createGuestSession() async {
    _session = null;
    return const Right(unit);
  }

  @override
  Future<Either<Failure, bool>> isPhoneNumberTaken(String phoneNumber) async =>
      Right(_byPhone.containsKey(phoneNumber));

  @override
  Future<Either<Failure, UserEntity>> upsertPhoneNumber(
    String userId,
    String phoneNumber,
  ) async {
    final entry = _byPhone.entries.firstWhere(
      (e) => e.value.user.id == userId,
      orElse: () => throw StateError('user $userId not found'),
    );
    final updated = entry.value.user.copyWith(phoneNumber: phoneNumber);
    _byPhone.remove(entry.key);
    _byPhone[phoneNumber] = _UserRecord(
      user: updated,
      password: entry.value.password,
    );
    return Right(updated);
  }
}

/// In-memory biometric repository.
///
/// - Hardware is always "ready" (R3.4: prompt may be invoked).
/// - The OS prompt is faked to succeed; toggle [authResult] in tests that
///   want to exercise the failure path.
/// - Credentials live in [_store] under `biometric_phone` /
///   `biometric_password` (R4.4 distinct keys).
/// - The `biometric_enabled` SharedPreferences flag is mirrored on
///   [storeCredentials] / [clearCredentials] (R4.4, R4.6).
class _FakeBiometricCredentialRepository
    implements BiometricCredentialRepository {
  _FakeBiometricCredentialRepository(this._prefs);

  final SharedPreferencesDataSource _prefs;
  final Map<String, String> _store = <String, String>{};

  /// Simulated hardware/user-preference status. Tests can override via
  /// [setStatus] to drive the unavailable / disabled branches.
  BiometricStatus _status = BiometricStatus.ready;

  /// Simulated OS prompt outcome. Defaults to success.
  Either<Failure, bool> authResult = const Right(true);

  void setStatus(BiometricStatus status) => _status = status;

  @override
  Future<Either<Failure, BiometricStatus>> getStatus() async =>
      Right(_status);

  @override
  Future<Either<Failure, bool>> authenticate({required String reason}) async =>
      authResult;

  @override
  Future<Either<Failure, Unit>> storeCredentials({
    required String phoneNumber,
    required String password,
  }) async {
    _store['biometric_phone'] = phoneNumber;
    _store['biometric_password'] = password;
    await _prefs.setBool(PrefKeys.biometricEnabled, true);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, ({String phoneNumber, String password})>>
      readCredentials() async {
    final phone = _store['biometric_phone'];
    final pass = _store['biometric_password'];
    if (phone == null || pass == null) {
      return const Left(
        Failure.cache(message: 'authBiometricSessionExpired'),
      );
    }
    return Right((phoneNumber: phone, password: pass));
  }

  @override
  Future<Either<Failure, Unit>> clearCredentials() async {
    _store.remove('biometric_phone');
    _store.remove('biometric_password');
    await _prefs.setBool(PrefKeys.biometricEnabled, false);
    return const Right(unit);
  }
}

/// In-memory [SharedPreferencesDataSource] used in place of the real
/// `shared_preferences`-backed implementation so the test does not rely on
/// platform channels. Stores values in a `Map<String, Object>`.
class _FakeSharedPreferencesDataSource implements SharedPreferencesDataSource {
  final Map<String, Object> _store = <String, Object>{};

  @override
  Future<void> setString(String key, String value) async => _store[key] = value;

  @override
  String? getString(String key) => _store[key] as String?;

  @override
  Future<void> setBool(String key, bool value) async => _store[key] = value;

  @override
  bool? getBool(String key) => _store[key] as bool?;

  @override
  Future<void> remove(String key) async => _store.remove(key);

  @override
  bool containsKey(String key) => _store.containsKey(key);
}

// ── Helpers ──────────────────────────────────────────────────────────────────

const _testPhone = '+6281234567890';
const _testPassword = 'password123';

UserEntity _seededUser() => const UserEntity(
      id: 'user-it-1',
      name: 'Integration Tester',
      phoneNumber: _testPhone,
      age: 65,
      gender: 'female',
      programLevel: ProgramLevel.beginner,
      healthConditions: [],
      emergencyContacts: [],
    );

/// Wires a real [AuthCubit] around the supplied fakes. The use cases are
/// real — only the repositories and prefs source are in-memory.
AuthCubit _buildAuthCubit({
  required _FakeAuthRepository authRepo,
  required _FakeBiometricCredentialRepository biometricRepo,
  required SharedPreferencesDataSource prefs,
}) {
  return AuthCubit(
    LoginUseCase(authRepo),
    RegisterUseCase(authRepo),
    LogoutUseCase(authRepo),
    GetSessionUseCase(authRepo),
    CreateGuestSessionUseCase(authRepo),
    prefs,
    CheckBiometricAvailabilityUseCase(biometricRepo),
    RestoreBiometricCredentialsUseCase(biometricRepo),
    ClearBiometricCredentialsUseCase(biometricRepo),
  );
}

Widget _harness(AuthCubit cubit) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AppCubit>(create: (_) => AppCubit()),
      BlocProvider<AuthCubit>.value(value: cubit),
    ],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('id')],
      locale: const Locale('en'),
      home: const LoginPage(),
    ),
  );
}

/// Polls until [predicate] returns true or [timeout] elapses, pumping the
/// widget tree on every tick so async cubit transitions get a chance to
/// run. Returns the elapsed time on success; throws `TestFailure`
/// otherwise.
Future<Duration> _pumpUntil(
  WidgetTester tester,
  bool Function() predicate, {
  Duration timeout = const Duration(seconds: 3),
  Duration step = const Duration(milliseconds: 50),
}) async {
  final start = DateTime.now();
  while (DateTime.now().difference(start) < timeout) {
    if (predicate()) {
      return DateTime.now().difference(start);
    }
    await tester.pump(step);
  }
  if (!predicate()) {
    throw TestFailure(
      'predicate not satisfied within ${timeout.inMilliseconds} ms',
    );
  }
  return DateTime.now().difference(start);
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // `LoginPage` reads [SharedPreferencesDataSource] from `getIt` to
    // manage the legacy-account warning flag. Wire the fake source into
    // GetIt so the page can resolve it without crashing.
    if (getIt.isRegistered<SharedPreferencesDataSource>()) {
      getIt.unregister<SharedPreferencesDataSource>();
    }
    getIt.registerSingleton<SharedPreferencesDataSource>(
      _FakeSharedPreferencesDataSource(),
    );
  });

  tearDown(() {
    if (getIt.isRegistered<SharedPreferencesDataSource>()) {
      getIt.unregister<SharedPreferencesDataSource>();
    }
  });

  testWidgets(
    'login with phone → enable biometric → re-login via biometric restore '
    '(R1.1, R1.4, R3.5, R4.3, R4.4)',
    (tester) async {
      // Arrange — fakes seeded with one known user.
      final prefs = getIt<SharedPreferencesDataSource>();
      final authRepo = _FakeAuthRepository()
        ..seed(user: _seededUser(), password: _testPassword);
      final biometricRepo = _FakeBiometricCredentialRepository(prefs);
      // Mark onboarding as already completed so a successful login routes
      // straight to [AuthAuthenticated] rather than [AuthNeedsOnboarding].
      await prefs.setBool(PrefKeys.onboardingComplete, true);

      final authCubit = _buildAuthCubit(
        authRepo: authRepo,
        biometricRepo: biometricRepo,
        prefs: prefs,
      );
      addTearDown(authCubit.close);

      // Act 1 — pump the login page.
      await tester.pumpWidget(_harness(authCubit));
      await tester.pumpAndSettle();

      // Act 2 — type phone + password and submit.
      // `LoginPage` exposes two TextFormFields; the first is phone, the
      // second is password.
      final fields = find.byType(TextFormField);
      expect(fields, findsNWidgets(2));
      await tester.enterText(fields.first, _testPhone);
      await tester.enterText(fields.last, _testPassword);

      // Tap the "Log In" primary button by its localized label.
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      await tester.tap(find.text(l10n.authLoginButton));
      await tester.pump(); // dispatch
      await tester.pump(const Duration(milliseconds: 50));

      // Assert — the cubit reached AuthAuthenticated with the seeded user
      // (R1.1, R1.4 — phone-first login pipeline succeeded).
      await _pumpUntil(tester, () => authCubit.state is AuthAuthenticated);
      final authedAfterLogin = authCubit.state as AuthAuthenticated;
      expect(authedAfterLogin.user.phoneNumber, equals(_testPhone));

      // Act 3 — simulate enabling biometric login (R4.3, R4.4). In the
      // real app this is performed by `SettingsCubit.enableBiometric`,
      // which is covered by its own unit/bloc test. Here we just persist
      // the credentials directly so the next biometric restore has
      // something to read; the contract under test for this integration
      // case is the LoginPage → AuthCubit → repository round-trip.
      final stored = await biometricRepo.storeCredentials(
        phoneNumber: _testPhone,
        password: _testPassword,
      );
      expect(stored.isRight(), isTrue);
      expect(
        prefs.getBool(PrefKeys.biometricEnabled),
        isTrue,
        reason: 'storeCredentials must flip biometric_enabled to true (R4.4).',
      );

      // Act 4 — logout to simulate the user returning later.
      await authCubit.logout();
      // Cubit logout clears credentials by default (R4.7 default behaviour);
      // re-store them to mimic the user having opted in to biometrics
      // ("biometric_keep_after_logout" is out-of-scope for the first
      // iteration but the credentials are normally re-populated next time
      // the user enables the toggle). For this restore-flow test we want
      // credentials present at the moment of biometric restore.
      await biometricRepo.storeCredentials(
        phoneNumber: _testPhone,
        password: _testPassword,
      );
      await tester.pumpAndSettle();
      expect(authCubit.state, isA<AuthUnauthenticated>());

      // The form controllers are owned by `LoginPage`'s `_LoginPageState`,
      // not the cubit. The previous login left the page intact, so the
      // controllers still hold the typed values. Clear them via the UI so
      // we can prove the autofill on the biometric-restore path actually
      // re-populates them rather than relying on stale text.
      await tester.enterText(fields.first, '');
      await tester.enterText(fields.last, '');
      await tester.pump();

      // Sanity: both fields are empty before tapping the biometric icon.
      TextField inner(Finder f) => tester.widget<TextField>(
            find.descendant(of: f, matching: find.byType(TextField)),
          );
      expect(inner(fields.first).controller!.text, isEmpty);
      expect(inner(fields.last).controller!.text, isEmpty);

      // Act 5 — tap the biometric icon. This kicks off
      // `AuthCubit.requestBiometricLogin`, which calls
      // CheckBiometricAvailability → Restore (OS prompt + read) → Login.
      await tester.tap(find.byIcon(Icons.fingerprint));
      await tester.pump();

      // Assert (R3.5) — autofill populated both controllers without any
      // further user interaction.
      await _pumpUntil(
        tester,
        () =>
            inner(fields.first).controller!.text == _testPhone &&
            inner(fields.last).controller!.text == _testPassword,
        timeout: const Duration(seconds: 2),
      );

      // Assert (R3.5, R3.8) — the standard login pipeline ran and the
      // cubit reached AuthAuthenticated for the same seeded user.
      await _pumpUntil(
        tester,
        () => authCubit.state is AuthAuthenticated,
        timeout: const Duration(seconds: 2),
      );
      final authedAfterRestore = authCubit.state as AuthAuthenticated;
      expect(
        authedAfterRestore.user.phoneNumber,
        equals(_testPhone),
        reason: 'Biometric restore must reach AuthAuthenticated for the '
            'same seeded user (R1.4, R3.5).',
      );
    },
  );
}
