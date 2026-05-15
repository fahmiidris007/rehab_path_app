import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/domain/enums/app_enums.dart';

part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    required AppThemeMode themeMode,
    required AppLocale locale,
    required FontSizeLevel fontSizeLevel,
  }) = _AppState;
}
