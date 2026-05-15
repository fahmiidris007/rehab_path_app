import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/domain/enums/app_enums.dart';
import 'app_state.dart';

export 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit()
      : super(
          const AppState(
            themeMode: AppThemeMode.system,
            locale: AppLocale.en,
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
}
