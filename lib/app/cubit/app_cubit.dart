import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../di/injection.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../shared/domain/enums/app_enums.dart';
import 'app_state.dart';

export 'app_state.dart';

@lazySingleton
class AppCubit extends Cubit<AppState> {
  AppCubit()
      : super(
          const AppState(
            themeMode: AppThemeMode.system,
            locale: AppLocale.id,
            fontSizeLevel: FontSizeLevel.defaultSize,
          ),
        );

  void changeTheme(AppThemeMode mode) => emit(state.copyWith(themeMode: mode));

  void changeLocale(AppLocale locale) =>
      emit(state.copyWith(locale: locale));

  void changeFontSize(FontSizeLevel level) =>
      emit(state.copyWith(fontSizeLevel: level));

  /// Returns the text-scale multiplier for the current [FontSizeLevel].
  double get fontSizeMultiplier => switch (state.fontSizeLevel) {
        FontSizeLevel.defaultSize => 1.0,
        FontSizeLevel.large => 1.25,
        FontSizeLevel.extraLarge => 1.5,
      };

  /// Loads persisted theme, locale, and font size settings from storage.
  ///
  /// Called on app startup so the UI reflects the user's last saved preferences
  /// before the first frame is rendered.
  Future<void> loadPersistedSettings() async {
    try {
      final settingsRepo = getIt<SettingsRepository>();
      final themeResult = await settingsRepo.getThemeMode();
      final localeResult = await settingsRepo.getLocale();
      final fontResult = await settingsRepo.getFontSizeLevel();

      final theme = themeResult.getOrElse(() => AppThemeMode.system);
      final locale = localeResult.getOrElse(() => AppLocale.id);
      final font = fontResult.getOrElse(() => FontSizeLevel.defaultSize);

      emit(state.copyWith(themeMode: theme, locale: locale, fontSizeLevel: font));
    } catch (_) {
      // Silently use defaults if loading fails.
    }
  }
}
