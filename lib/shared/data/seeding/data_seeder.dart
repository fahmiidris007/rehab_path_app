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

  /// On first launch (when [PrefKeys.seedingComplete] is unset), seed the
  /// user catalogue and historical session data from JSON assets and mark
  /// seeding complete. Subsequent launches return early so existing user
  /// records — including manual `phoneNumber` updates from the profile
  /// screen — are never overwritten.
  ///
  /// Validates: Requirement 14.5.
  Future<void> seedIfNeeded() async {
    if (_prefsDataSource.getBool(PrefKeys.seedingComplete) == true) return;

    try {
      // On a truly fresh install the seeding flag is absent. However, Android
      // backup may have restored SharedPreferences from a previous install,
      // including a stale session token. Clear any leftover session data so
      // the app always starts at the Welcome screen on first launch.
      await _prefsDataSource.remove(PrefKeys.sessionToken);
      await _prefsDataSource.remove(PrefKeys.sessionUserId);
      await _prefsDataSource.remove(PrefKeys.isGuest);
      await _prefsDataSource.remove(PrefKeys.onboardingComplete);

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
