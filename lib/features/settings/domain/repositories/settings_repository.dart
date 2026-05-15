import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/enums/app_enums.dart';

abstract class SettingsRepository {
  Future<Either<Failure, Unit>> saveThemeMode(AppThemeMode mode);
  Future<Either<Failure, AppThemeMode>> getThemeMode();
  Future<Either<Failure, Unit>> saveLocale(AppLocale locale);
  Future<Either<Failure, AppLocale>> getLocale();
  Future<Either<Failure, Unit>> saveFontSizeLevel(FontSizeLevel level);
  Future<Either<Failure, FontSizeLevel>> getFontSizeLevel();
  Future<Either<Failure, Unit>> saveNotificationsEnabled(bool enabled);
  Future<Either<Failure, bool>> getNotificationsEnabled();
}
