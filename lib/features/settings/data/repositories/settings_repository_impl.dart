import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../core/constants/pref_keys.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/data/datasources/shared_preferences_data_source.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../../domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferencesDataSource _prefsDataSource;
  final Logger _logger;

  SettingsRepositoryImpl(this._prefsDataSource, this._logger);

  @override
  Future<Either<Failure, Unit>> saveThemeMode(AppThemeMode mode) async {
    try {
      await _prefsDataSource.setString(PrefKeys.themeMode, mode.name);
      return const Right(unit);
    } catch (e, st) {
      _logger.e('SaveThemeMode failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppThemeMode>> getThemeMode() async {
    try {
      final value = _prefsDataSource.getString(PrefKeys.themeMode);
      final mode = value != null
          ? AppThemeMode.values.firstWhere(
              (e) => e.name == value,
              orElse: () => AppThemeMode.system,
            )
          : AppThemeMode.system;
      return Right(mode);
    } catch (e, st) {
      _logger.e('GetThemeMode failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveLocale(AppLocale locale) async {
    try {
      await _prefsDataSource.setString(PrefKeys.locale, locale.name);
      return const Right(unit);
    } catch (e, st) {
      _logger.e('SaveLocale failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppLocale>> getLocale() async {
    try {
      final value = _prefsDataSource.getString(PrefKeys.locale);
      final locale = value != null
          ? AppLocale.values.firstWhere(
              (e) => e.name == value,
              orElse: () => AppLocale.id,
            )
          : AppLocale.id;
      return Right(locale);
    } catch (e, st) {
      _logger.e('GetLocale failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveFontSizeLevel(FontSizeLevel level) async {
    try {
      await _prefsDataSource.setString(PrefKeys.fontSizeLevel, level.name);
      return const Right(unit);
    } catch (e, st) {
      _logger.e('SaveFontSizeLevel failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FontSizeLevel>> getFontSizeLevel() async {
    try {
      final value = _prefsDataSource.getString(PrefKeys.fontSizeLevel);
      final level = value != null
          ? FontSizeLevel.values.firstWhere(
              (e) => e.name == value,
              orElse: () => FontSizeLevel.defaultSize,
            )
          : FontSizeLevel.defaultSize;
      return Right(level);
    } catch (e, st) {
      _logger.e('GetFontSizeLevel failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveNotificationsEnabled(bool enabled) async {
    try {
      await _prefsDataSource.setBool(PrefKeys.notificationsEnabled, enabled);
      return const Right(unit);
    } catch (e, st) {
      _logger.e('SaveNotificationsEnabled failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> getNotificationsEnabled() async {
    try {
      final value =
          _prefsDataSource.getBool(PrefKeys.notificationsEnabled) ?? false;
      return Right(value);
    } catch (e, st) {
      _logger.e('GetNotificationsEnabled failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveVoiceCuesEnabled(bool enabled) async {
    try {
      await _prefsDataSource.setBool(PrefKeys.voiceCuesEnabled, enabled);
      return const Right(unit);
    } catch (e, st) {
      _logger.e('SaveVoiceCuesEnabled failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> getVoiceCuesEnabled() async {
    try {
      final value =
          _prefsDataSource.getBool(PrefKeys.voiceCuesEnabled) ?? false;
      return Right(value);
    } catch (e, st) {
      _logger.e('GetVoiceCuesEnabled failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }
}
