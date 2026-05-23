import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../app/cubit/app_cubit.dart';
import '../../../../core/constants/pref_keys.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/data/datasources/shared_preferences_data_source.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../../../auth/domain/repositories/biometric_credential_repository.dart';
import '../../../auth/domain/usecases/check_biometric_availability_use_case.dart';
import '../../../auth/domain/usecases/clear_biometric_credentials_use_case.dart';
import '../../../auth/domain/usecases/login_use_case.dart';
import '../../../auth/domain/usecases/store_biometric_credentials_use_case.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../notifications/domain/usecases/request_notification_permission_use_case.dart';
import '../../domain/usecases/get_font_size_level_use_case.dart';
import '../../domain/usecases/get_locale_use_case.dart';
import '../../domain/usecases/get_notifications_enabled_use_case.dart';
import '../../domain/usecases/get_theme_mode_use_case.dart';
import '../../domain/usecases/get_voice_cues_enabled_use_case.dart';
import '../../domain/usecases/save_font_size_level_use_case.dart';
import '../../domain/usecases/save_locale_use_case.dart';
import '../../domain/usecases/save_notifications_enabled_use_case.dart';
import '../../domain/usecases/save_theme_mode_use_case.dart';
import '../../domain/usecases/save_voice_cues_enabled_use_case.dart';
import 'settings_state.dart';

export 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final GetThemeModeUseCase _getThemeModeUseCase;
  final SaveThemeModeUseCase _saveThemeModeUseCase;
  final GetLocaleUseCase _getLocaleUseCase;
  final SaveLocaleUseCase _saveLocaleUseCase;
  final GetFontSizeLevelUseCase _getFontSizeLevelUseCase;
  final SaveFontSizeLevelUseCase _saveFontSizeLevelUseCase;
  final GetNotificationsEnabledUseCase _getNotificationsEnabledUseCase;
  final SaveNotificationsEnabledUseCase _saveNotificationsEnabledUseCase;
  final RequestNotificationPermissionUseCase
      _requestNotificationPermissionUseCase;
  final GetVoiceCuesEnabledUseCase _getVoiceCuesEnabledUseCase;
  final SaveVoiceCuesEnabledUseCase _saveVoiceCuesEnabledUseCase;
  final AppCubit _appCubit;
  final CheckBiometricAvailabilityUseCase _checkBiometricUseCase;
  final StoreBiometricCredentialsUseCase _storeBiometricUseCase;
  final ClearBiometricCredentialsUseCase _clearBiometricUseCase;
  final LoginUseCase _loginUseCase;
  final BiometricCredentialRepository _biometricRepo;
  final AuthCubit _authCubit;
  final SharedPreferencesDataSource _prefsDataSource;

  SettingsCubit(
    this._getThemeModeUseCase,
    this._saveThemeModeUseCase,
    this._getLocaleUseCase,
    this._saveLocaleUseCase,
    this._getFontSizeLevelUseCase,
    this._saveFontSizeLevelUseCase,
    this._getNotificationsEnabledUseCase,
    this._saveNotificationsEnabledUseCase,
    this._requestNotificationPermissionUseCase,
    this._getVoiceCuesEnabledUseCase,
    this._saveVoiceCuesEnabledUseCase,
    this._appCubit,
    this._checkBiometricUseCase,
    this._storeBiometricUseCase,
    this._clearBiometricUseCase,
    this._loginUseCase,
    this._biometricRepo,
    this._authCubit,
    this._prefsDataSource,
  ) : super(const SettingsState.loading());

  Future<void> loadSettings() async {
    emit(const SettingsState.loading());
    final themeResult = await _getThemeModeUseCase(const NoParams());
    final localeResult = await _getLocaleUseCase(const NoParams());
    final fontResult = await _getFontSizeLevelUseCase(const NoParams());
    final notifResult = await _getNotificationsEnabledUseCase(const NoParams());
    final voiceResult = await _getVoiceCuesEnabledUseCase(const NoParams());
    final biometricStatusResult =
        await _checkBiometricUseCase(const NoParams());

    final theme = themeResult.getOrElse(() => AppThemeMode.system);
    final locale = localeResult.getOrElse(() => AppLocale.en);
    final font = fontResult.getOrElse(() => FontSizeLevel.defaultSize);
    final notif = notifResult.getOrElse(() => false);
    final voice = voiceResult.getOrElse(() => false);
    final biometricStatus =
        biometricStatusResult.getOrElse(() => BiometricStatus.unavailable);
    final biometricCapable = biometricStatus != BiometricStatus.unavailable;
    // Use the SharedPreferences flag as the source of truth for the toggle
    // state; it is kept in sync with secure-storage by storeCredentials /
    // clearCredentials on the repository side.
    final biometricEnabled = biometricCapable &&
        (_prefsDataSource.getBool(PrefKeys.biometricEnabled) ?? false);

    emit(SettingsState.loaded(SettingsData(
      themeMode: theme,
      locale: locale,
      fontSizeLevel: font,
      notificationsEnabled: notif,
      voiceCuesEnabled: voice,
      biometricEnabled: biometricEnabled,
      biometricCapable: biometricCapable,
    )));
  }

  Future<void> changeTheme(AppThemeMode mode) async {
    await _saveThemeModeUseCase(mode);
    _appCubit.changeTheme(mode);
    if (state is SettingsLoaded) {
      emit(SettingsState.loaded(
          (state as SettingsLoaded).data.copyWith(themeMode: mode)));
    }
  }

  Future<void> changeLocale(AppLocale locale) async {
    await _saveLocaleUseCase(locale);
    _appCubit.changeLocale(locale);
    if (state is SettingsLoaded) {
      emit(SettingsState.loaded(
          (state as SettingsLoaded).data.copyWith(locale: locale)));
    }
  }

  Future<void> changeFontSize(FontSizeLevel level) async {
    await _saveFontSizeLevelUseCase(level);
    _appCubit.changeFontSize(level);
    if (state is SettingsLoaded) {
      emit(SettingsState.loaded(
          (state as SettingsLoaded).data.copyWith(fontSizeLevel: level)));
    }
  }

  Future<void> toggleNotifications(bool enabled) async {
    // When enabling notifications, request OS permission first.
    if (enabled) {
      final permResult =
          await _requestNotificationPermissionUseCase(const NoParams());
      final granted = permResult.getOrElse(() => false);
      if (!granted) {
        // Permission denied — revert the toggle and signal the UI.
        final currentData = state is SettingsLoaded
            ? (state as SettingsLoaded).data
            : state is SettingsNotificationPermissionDenied
                ? (state as SettingsNotificationPermissionDenied).data
                : null;
        if (currentData != null) {
          emit(SettingsState.notificationPermissionDenied(currentData));
        }
        return;
      }
    }
    await _saveNotificationsEnabledUseCase(
        SaveNotificationsEnabledParams(enabled: enabled));
    if (state is SettingsLoaded ||
        state is SettingsNotificationPermissionDenied) {
      final currentData = state is SettingsLoaded
          ? (state as SettingsLoaded).data
          : (state as SettingsNotificationPermissionDenied).data;
      emit(SettingsState.loaded(
          currentData.copyWith(notificationsEnabled: enabled)));
    }
  }

  Future<void> toggleVoiceCues(bool enabled) async {
    await _saveVoiceCuesEnabledUseCase(
        SaveVoiceCuesEnabledParams(enabled: enabled));
    if (state is SettingsLoaded) {
      emit(SettingsState.loaded(
          (state as SettingsLoaded).data.copyWith(voiceCuesEnabled: enabled)));
    }
  }

  /// Enables biometric login for the currently authenticated user.
  ///
  /// Flow (R4.3, R4.4, R4.5):
  /// 1. The auth state must be [AuthAuthenticated]; otherwise we cannot
  ///    associate credentials with a user.
  /// 2. Verify [enteredPassword] silently by replaying [LoginUseCase] with
  ///    the current user's phone number; this is the only legitimate way
  ///    to confirm the password without retyping it on next login.
  /// 3. Trigger the OS biometric prompt with the supplied localized
  ///    [reason] (the cubit cannot resolve `AppLocalizations` itself).
  /// 4. Persist `(phoneNumber, password)` via [StoreBiometricCredentialsUseCase],
  ///    which sets the `biometric_enabled` flag to true.
  ///
  /// On any failure we emit [SettingsError] with the
  /// `settingsBiometricEnableFailed` key and re-emit the loaded data with
  /// `biometricEnabled: false` so the toggle visibly returns to off (R4.5).
  /// We also defensively clear secure storage on a partial-write failure
  /// to avoid orphan entries.
  Future<void> enableBiometric({
    required String enteredPassword,
    required String reason,
  }) async {
    final currentData =
        state is SettingsLoaded ? (state as SettingsLoaded).data : null;

    final authState = _authCubit.state;
    if (authState is! AuthAuthenticated) {
      _emitBiometricEnableFailure(currentData);
      return;
    }
    final phoneNumber = authState.user.phoneNumber;

    // Step 1: silently verify the password by replaying LoginUseCase.
    final loginResult = await _loginUseCase(
      LoginParams(phoneNumber: phoneNumber, password: enteredPassword),
    );
    final passwordOk = loginResult.isRight();
    if (!passwordOk) {
      _emitBiometricEnableFailure(currentData);
      return;
    }

    // Step 2: invoke the OS biometric prompt.
    final authResult = await _biometricRepo.authenticate(reason: reason);
    final biometricOk = authResult.fold((_) => false, (ok) => ok);
    if (!biometricOk) {
      _emitBiometricEnableFailure(currentData);
      return;
    }

    // Step 3: persist credentials in secure storage.
    final storeResult = await _storeBiometricUseCase(
      StoreBiometricCredentialsParams(
        phoneNumber: phoneNumber,
        password: enteredPassword,
      ),
    );
    final stored = storeResult.isRight();
    if (!stored) {
      // Defensive cleanup so we never leave half-written secure storage.
      await _clearBiometricUseCase(const NoParams());
      _emitBiometricEnableFailure(currentData);
      return;
    }

    if (currentData != null) {
      emit(SettingsState.loaded(
        currentData.copyWith(biometricEnabled: true, biometricCapable: true),
      ));
    }
  }

  /// Disables biometric login without triggering the OS prompt (R4.6).
  ///
  /// Clears both secure-storage credential keys and resets the
  /// `biometric_enabled` flag, then re-emits the loaded settings with the
  /// toggle off.
  Future<void> disableBiometric() async {
    await _clearBiometricUseCase(const NoParams());
    if (state is SettingsLoaded) {
      emit(SettingsState.loaded(
        (state as SettingsLoaded)
            .data
            .copyWith(biometricEnabled: false),
      ));
    }
  }

  void _emitBiometricEnableFailure(SettingsData? currentData) {
    emit(const SettingsState.error('settingsBiometricEnableFailed'));
    if (currentData != null) {
      emit(SettingsState.loaded(
        currentData.copyWith(biometricEnabled: false),
      ));
    }
  }
}
