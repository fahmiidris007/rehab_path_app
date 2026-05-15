import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../app/cubit/app_cubit.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/enums/app_enums.dart';
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
import '../../../notifications/domain/usecases/request_notification_permission_use_case.dart';
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
  ) : super(const SettingsState.loading());

  Future<void> loadSettings() async {
    emit(const SettingsState.loading());
    final themeResult = await _getThemeModeUseCase(const NoParams());
    final localeResult = await _getLocaleUseCase(const NoParams());
    final fontResult = await _getFontSizeLevelUseCase(const NoParams());
    final notifResult = await _getNotificationsEnabledUseCase(const NoParams());
    final voiceResult = await _getVoiceCuesEnabledUseCase(const NoParams());

    final theme = themeResult.getOrElse(() => AppThemeMode.system);
    final locale = localeResult.getOrElse(() => AppLocale.en);
    final font = fontResult.getOrElse(() => FontSizeLevel.defaultSize);
    final notif = notifResult.getOrElse(() => false);
    final voice = voiceResult.getOrElse(() => false);

    emit(SettingsState.loaded(SettingsData(
      themeMode: theme,
      locale: locale,
      fontSizeLevel: font,
      notificationsEnabled: notif,
      voiceCuesEnabled: voice,
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
}
