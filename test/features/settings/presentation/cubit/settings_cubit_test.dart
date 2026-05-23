// Tests for [SettingsCubit.enableBiometric] rollback paths.
//
// Validates: Requirements 4.5, 4.6.
//
// Task 6.5 from `.kiro/specs/app-flow-adjustments/tasks.md`:
//   - OS prompt failure  — biometric `authenticate` returns Right(false)
//   - Password mismatch  — `LoginUseCase` returns Left(_)
//   - Storage error      — `_storeBiometricUseCase` returns Left(_) (and
//                          `_clearBiometricUseCase` is invoked defensively)
//   - Auth state not authenticated — short-circuit without invoking any
//                                    of the biometric collaborators
//
// Each path must:
//   1. Emit `SettingsState.error('settingsBiometricEnableFailed')`.
//   2. Re-emit `SettingsLoaded` with `biometricEnabled: false` so the
//      toggle visibly snaps back to off (R4.5).
//   3. Leave secure storage in a clean state — no orphan
//      `_storeBiometricUseCase` invocations on the failure paths (R4.6).
//
// Test strategy
// -------------
// `SettingsCubit` takes 19 collaborators in its constructor. We mock all
// of them with `mocktail`. The two cubit collaborators (`AppCubit`,
// `AuthCubit`) are mocked via `bloc_test`'s `MockCubit` so we can stub
// `state` without subclassing the real Cubits.
//
// We seed each test directly with a `SettingsLoaded` state mirroring the
// snapshot `loadSettings()` produces (`biometricCapable: true`,
// `biometricEnabled: false`) and exercise `enableBiometric` from there.

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:rehab_path_app/app/cubit/app_cubit.dart';
import 'package:rehab_path_app/core/errors/failures.dart';
import 'package:rehab_path_app/core/usecases/use_case.dart';
import 'package:rehab_path_app/features/auth/domain/repositories/biometric_credential_repository.dart';
import 'package:rehab_path_app/features/auth/domain/usecases/check_biometric_availability_use_case.dart';
import 'package:rehab_path_app/features/auth/domain/usecases/clear_biometric_credentials_use_case.dart';
import 'package:rehab_path_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:rehab_path_app/features/auth/domain/usecases/store_biometric_credentials_use_case.dart';
import 'package:rehab_path_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:rehab_path_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:rehab_path_app/features/notifications/domain/usecases/request_notification_permission_use_case.dart';
import 'package:rehab_path_app/features/settings/domain/usecases/get_font_size_level_use_case.dart';
import 'package:rehab_path_app/features/settings/domain/usecases/get_locale_use_case.dart';
import 'package:rehab_path_app/features/settings/domain/usecases/get_notifications_enabled_use_case.dart';
import 'package:rehab_path_app/features/settings/domain/usecases/get_theme_mode_use_case.dart';
import 'package:rehab_path_app/features/settings/domain/usecases/get_voice_cues_enabled_use_case.dart';
import 'package:rehab_path_app/features/settings/domain/usecases/save_font_size_level_use_case.dart';
import 'package:rehab_path_app/features/settings/domain/usecases/save_locale_use_case.dart';
import 'package:rehab_path_app/features/settings/domain/usecases/save_notifications_enabled_use_case.dart';
import 'package:rehab_path_app/features/settings/domain/usecases/save_theme_mode_use_case.dart';
import 'package:rehab_path_app/features/settings/domain/usecases/save_voice_cues_enabled_use_case.dart';
import 'package:rehab_path_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:rehab_path_app/shared/data/datasources/shared_preferences_data_source.dart';
import 'package:rehab_path_app/shared/domain/entities/user_entity.dart';
import 'package:rehab_path_app/shared/domain/enums/app_enums.dart';

// ── Mocks ────────────────────────────────────────────────────────────────────

class _MockGetThemeModeUseCase extends Mock implements GetThemeModeUseCase {}

class _MockSaveThemeModeUseCase extends Mock implements SaveThemeModeUseCase {}

class _MockGetLocaleUseCase extends Mock implements GetLocaleUseCase {}

class _MockSaveLocaleUseCase extends Mock implements SaveLocaleUseCase {}

class _MockGetFontSizeLevelUseCase extends Mock
    implements GetFontSizeLevelUseCase {}

class _MockSaveFontSizeLevelUseCase extends Mock
    implements SaveFontSizeLevelUseCase {}

class _MockGetNotificationsEnabledUseCase extends Mock
    implements GetNotificationsEnabledUseCase {}

class _MockSaveNotificationsEnabledUseCase extends Mock
    implements SaveNotificationsEnabledUseCase {}

class _MockRequestNotificationPermissionUseCase extends Mock
    implements RequestNotificationPermissionUseCase {}

class _MockGetVoiceCuesEnabledUseCase extends Mock
    implements GetVoiceCuesEnabledUseCase {}

class _MockSaveVoiceCuesEnabledUseCase extends Mock
    implements SaveVoiceCuesEnabledUseCase {}

class _MockAppCubit extends MockCubit<AppState> implements AppCubit {}

class _MockCheckBiometricUseCase extends Mock
    implements CheckBiometricAvailabilityUseCase {}

class _MockStoreBiometricUseCase extends Mock
    implements StoreBiometricCredentialsUseCase {}

class _MockClearBiometricUseCase extends Mock
    implements ClearBiometricCredentialsUseCase {}

class _MockLoginUseCase extends Mock implements LoginUseCase {}

class _MockBiometricRepo extends Mock
    implements BiometricCredentialRepository {}

class _MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class _MockPrefsDataSource extends Mock
    implements SharedPreferencesDataSource {}

// ── Fixtures ────────────────────────────────────────────────────────────────

const _password = 'correct-horse-battery-staple';
const _wrongPassword = 'wrong-password';
const _reason = 'test reason';

UserEntity _buildUser() => const UserEntity(
      id: 'user-1',
      name: 'Tester',
      phoneNumber: '+6281234567890',
      age: 65,
      gender: 'male',
      programLevel: ProgramLevel.beginner,
      healthConditions: [],
      emergencyContacts: [],
    );

SettingsData _baseLoadedData() => const SettingsData(
      themeMode: AppThemeMode.system,
      locale: AppLocale.en,
      fontSizeLevel: FontSizeLevel.defaultSize,
      notificationsEnabled: false,
      voiceCuesEnabled: false,
      biometricEnabled: false,
      biometricCapable: true,
    );

class _Fixture {
  final _MockGetThemeModeUseCase getTheme;
  final _MockSaveThemeModeUseCase saveTheme;
  final _MockGetLocaleUseCase getLocale;
  final _MockSaveLocaleUseCase saveLocale;
  final _MockGetFontSizeLevelUseCase getFont;
  final _MockSaveFontSizeLevelUseCase saveFont;
  final _MockGetNotificationsEnabledUseCase getNotif;
  final _MockSaveNotificationsEnabledUseCase saveNotif;
  final _MockRequestNotificationPermissionUseCase requestPerm;
  final _MockGetVoiceCuesEnabledUseCase getVoice;
  final _MockSaveVoiceCuesEnabledUseCase saveVoice;
  final _MockAppCubit appCubit;
  final _MockCheckBiometricUseCase checkBiometric;
  final _MockStoreBiometricUseCase storeBiometric;
  final _MockClearBiometricUseCase clearBiometric;
  final _MockLoginUseCase login;
  final _MockBiometricRepo biometricRepo;
  final _MockAuthCubit authCubit;
  final _MockPrefsDataSource prefs;

  _Fixture._({
    required this.getTheme,
    required this.saveTheme,
    required this.getLocale,
    required this.saveLocale,
    required this.getFont,
    required this.saveFont,
    required this.getNotif,
    required this.saveNotif,
    required this.requestPerm,
    required this.getVoice,
    required this.saveVoice,
    required this.appCubit,
    required this.checkBiometric,
    required this.storeBiometric,
    required this.clearBiometric,
    required this.login,
    required this.biometricRepo,
    required this.authCubit,
    required this.prefs,
  });

  factory _Fixture.create() {
    return _Fixture._(
      getTheme: _MockGetThemeModeUseCase(),
      saveTheme: _MockSaveThemeModeUseCase(),
      getLocale: _MockGetLocaleUseCase(),
      saveLocale: _MockSaveLocaleUseCase(),
      getFont: _MockGetFontSizeLevelUseCase(),
      saveFont: _MockSaveFontSizeLevelUseCase(),
      getNotif: _MockGetNotificationsEnabledUseCase(),
      saveNotif: _MockSaveNotificationsEnabledUseCase(),
      requestPerm: _MockRequestNotificationPermissionUseCase(),
      getVoice: _MockGetVoiceCuesEnabledUseCase(),
      saveVoice: _MockSaveVoiceCuesEnabledUseCase(),
      appCubit: _MockAppCubit(),
      checkBiometric: _MockCheckBiometricUseCase(),
      storeBiometric: _MockStoreBiometricUseCase(),
      clearBiometric: _MockClearBiometricUseCase(),
      login: _MockLoginUseCase(),
      biometricRepo: _MockBiometricRepo(),
      authCubit: _MockAuthCubit(),
      prefs: _MockPrefsDataSource(),
    );
  }

  SettingsCubit buildCubit() => SettingsCubit(
        getTheme,
        saveTheme,
        getLocale,
        saveLocale,
        getFont,
        saveFont,
        getNotif,
        saveNotif,
        requestPerm,
        getVoice,
        saveVoice,
        appCubit,
        checkBiometric,
        storeBiometric,
        clearBiometric,
        login,
        biometricRepo,
        authCubit,
        prefs,
      );
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const LoginParams(phoneNumber: '_fallback', password: '_fallback'),
    );
    registerFallbackValue(
      const StoreBiometricCredentialsParams(
        phoneNumber: '_fallback',
        password: '_fallback',
      ),
    );
  });

  group('SettingsCubit.enableBiometric rollback paths', () {
    late _Fixture fx;
    late SettingsData loadedData;
    final user = _buildUser();

    final expectedRollbackStates = <SettingsState>[
      const SettingsState.error('settingsBiometricEnableFailed'),
      // The seeded `biometricEnabled` is already false, so the rollback
      // copy preserves the same data shape — what we assert is that the
      // cubit returns to a `SettingsLoaded` state with the toggle off.
      SettingsLoaded(_baseLoadedData().copyWith(biometricEnabled: false)),
    ];

    setUp(() {
      fx = _Fixture.create();
      loadedData = _baseLoadedData();
    });

    // ─────────────────────────────────────────────────────────────────────
    // Case 1 — OS biometric prompt fails (R4.5).
    //
    // Login (silent password verification) succeeds, but the OS biometric
    // prompt returns `Right(false)`. The cubit must roll back the toggle
    // and never reach `_storeBiometricUseCase`.
    // ─────────────────────────────────────────────────────────────────────
    blocTest<SettingsCubit, SettingsState>(
      'OS prompt failure (Right(false)) — error + rollback to '
      'biometricEnabled=false; storeBiometricUseCase NOT invoked',
      setUp: () {
        when(() => fx.authCubit.state)
            .thenReturn(AuthState.authenticated(user));
        when(() => fx.login(any()))
            .thenAnswer((_) async => Right(user));
        when(() => fx.biometricRepo.authenticate(reason: any(named: 'reason')))
            .thenAnswer((_) async => const Right(false));
      },
      build: () => fx.buildCubit(),
      seed: () => SettingsLoaded(loadedData),
      act: (cubit) => cubit.enableBiometric(
        enteredPassword: _password,
        reason: _reason,
      ),
      expect: () => expectedRollbackStates,
      verify: (_) {
        verifyNever(() => fx.storeBiometric(any()));
        verifyNever(() => fx.clearBiometric(const NoParams()));
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'OS prompt failure (Left(failure)) — error + rollback to '
      'biometricEnabled=false; storeBiometricUseCase NOT invoked',
      setUp: () {
        when(() => fx.authCubit.state)
            .thenReturn(AuthState.authenticated(user));
        when(() => fx.login(any()))
            .thenAnswer((_) async => Right(user));
        when(() => fx.biometricRepo.authenticate(reason: any(named: 'reason')))
            .thenAnswer(
          (_) async =>
              const Left(Failure.unexpected(message: 'authBiometricFailed')),
        );
      },
      build: () => fx.buildCubit(),
      seed: () => SettingsLoaded(loadedData),
      act: (cubit) => cubit.enableBiometric(
        enteredPassword: _password,
        reason: _reason,
      ),
      expect: () => expectedRollbackStates,
      verify: (_) {
        verifyNever(() => fx.storeBiometric(any()));
        verifyNever(() => fx.clearBiometric(const NoParams()));
      },
    );

    // ─────────────────────────────────────────────────────────────────────
    // Case 2 — Password mismatch (R4.5).
    //
    // The silent `LoginUseCase` replay returns `Left(_)` (wrong password).
    // The cubit must roll back without ever invoking the OS biometric
    // prompt or writing to secure storage.
    // ─────────────────────────────────────────────────────────────────────
    blocTest<SettingsCubit, SettingsState>(
      'Password mismatch — error + rollback; biometric prompt and '
      'storeBiometricUseCase NOT invoked',
      setUp: () {
        when(() => fx.authCubit.state)
            .thenReturn(AuthState.authenticated(user));
        when(() => fx.login(any())).thenAnswer(
          (_) async =>
              const Left(Failure.cache(message: 'authInvalidCredentials')),
        );
      },
      build: () => fx.buildCubit(),
      seed: () => SettingsLoaded(loadedData),
      act: (cubit) => cubit.enableBiometric(
        enteredPassword: _wrongPassword,
        reason: _reason,
      ),
      expect: () => expectedRollbackStates,
      verify: (_) {
        verifyNever(
          () => fx.biometricRepo.authenticate(reason: any(named: 'reason')),
        );
        verifyNever(() => fx.storeBiometric(any()));
        verifyNever(() => fx.clearBiometric(const NoParams()));
      },
    );

    // ─────────────────────────────────────────────────────────────────────
    // Case 3 — Storage error (R4.5, R4.6).
    //
    // Login succeeds, the biometric prompt succeeds, but
    // `_storeBiometricUseCase` returns `Left(_)`. The cubit must call
    // `_clearBiometricUseCase` defensively to avoid leaving an orphan
    // half-written secure-storage entry, then roll back.
    // ─────────────────────────────────────────────────────────────────────
    blocTest<SettingsCubit, SettingsState>(
      'Storage error — error + rollback; clearBiometricUseCase invoked '
      'defensively exactly once',
      setUp: () {
        when(() => fx.authCubit.state)
            .thenReturn(AuthState.authenticated(user));
        when(() => fx.login(any()))
            .thenAnswer((_) async => Right(user));
        when(() => fx.biometricRepo.authenticate(reason: any(named: 'reason')))
            .thenAnswer((_) async => const Right(true));
        when(() => fx.storeBiometric(any())).thenAnswer(
          (_) async =>
              const Left(Failure.unexpected(message: 'secureStorageWriteFailed')),
        );
        when(() => fx.clearBiometric(const NoParams()))
            .thenAnswer((_) async => const Right(unit));
      },
      build: () => fx.buildCubit(),
      seed: () => SettingsLoaded(loadedData),
      act: (cubit) => cubit.enableBiometric(
        enteredPassword: _password,
        reason: _reason,
      ),
      expect: () => expectedRollbackStates,
      verify: (_) {
        verify(() => fx.clearBiometric(const NoParams())).called(1);
      },
    );

    // ─────────────────────────────────────────────────────────────────────
    // Case 4 — Auth state is not [AuthAuthenticated] (R4.5).
    //
    // `enableBiometric` short-circuits with a failure rollback. None of
    // the biometric, login, or storage collaborators may be invoked.
    // ─────────────────────────────────────────────────────────────────────
    blocTest<SettingsCubit, SettingsState>(
      'Auth state not authenticated — error + rollback; no use cases '
      'invoked at all',
      setUp: () {
        when(() => fx.authCubit.state)
            .thenReturn(const AuthState.unauthenticated());
      },
      build: () => fx.buildCubit(),
      seed: () => SettingsLoaded(loadedData),
      act: (cubit) => cubit.enableBiometric(
        enteredPassword: _password,
        reason: _reason,
      ),
      expect: () => expectedRollbackStates,
      verify: (_) {
        verifyNever(() => fx.login(any()));
        verifyNever(
          () => fx.biometricRepo.authenticate(reason: any(named: 'reason')),
        );
        verifyNever(() => fx.storeBiometric(any()));
        verifyNever(() => fx.clearBiometric(const NoParams()));
      },
    );
  });
}
