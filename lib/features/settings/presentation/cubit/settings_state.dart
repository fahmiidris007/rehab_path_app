import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/enums/app_enums.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsData with _$SettingsData {
  const factory SettingsData({
    required AppThemeMode themeMode,
    required AppLocale locale,
    required FontSizeLevel fontSizeLevel,
    required bool notificationsEnabled,
    @Default(false) bool voiceCuesEnabled,
  }) = _SettingsData;
}

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState.loading() = SettingsLoading;
  const factory SettingsState.loaded(SettingsData data) = SettingsLoaded;
  const factory SettingsState.error(String message) = SettingsError;
  /// Emitted when the user tries to enable notifications but OS permission
  /// was denied. The [data] field holds the current settings (notifications
  /// remain disabled so the toggle reverts).
  const factory SettingsState.notificationPermissionDenied(SettingsData data) =
      SettingsNotificationPermissionDenied;
}
