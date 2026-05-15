import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../core/constants/pref_keys.dart';
import '../datasources/dummy_data_source.dart';
import '../datasources/hive_data_source.dart';
import '../datasources/shared_preferences_data_source.dart';
import '../models/exercise_session_hive_model.dart';
import '../models/user_hive_model.dart';

/// Seeds Hive boxes from JSON assets on first launch.
///
/// Checks [PrefKeys.seedingComplete] before seeding so the operation runs
/// only once. Errors are caught and logged without crashing the app.
@lazySingleton
class DataSeeder {
  final DummyDataSource _dummyDataSource;
  final HiveDataSource _hiveDataSource;
  final SharedPreferencesDataSource _prefsDataSource;
  final Logger _logger;

  DataSeeder(
    this._dummyDataSource,
    this._hiveDataSource,
    this._prefsDataSource,
    this._logger,
  );

  Future<void> seedIfNeeded() async {
    if (_prefsDataSource.getBool(PrefKeys.seedingComplete) == true) return;

    try {
      // Seed users
      final users = await _dummyDataSource.loadUsers();
      for (final user in users) {
        await _hiveDataSource.saveUser(UserHiveModel.fromEntity(user));
      }

      // Seed sessions from progress data
      final progress = await _dummyDataSource.loadProgress();
      for (final session in progress.sessions) {
        await _hiveDataSource
            .saveSession(ExerciseSessionHiveModel.fromEntity(session));
      }

      await _prefsDataSource.setBool(PrefKeys.seedingComplete, true);
      _logger.i('Data seeding completed successfully');
    } catch (e, st) {
      _logger.e('Seeding failed', error: e, stackTrace: st);
      // Non-blocking: app continues but data will be empty until next launch
    }
  }
}
