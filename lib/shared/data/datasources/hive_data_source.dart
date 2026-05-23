import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants/app_constants.dart';
import '../models/badge_hive_model.dart';
import '../models/exercise_session_hive_model.dart';
import '../models/fall_event_hive_model.dart';
import '../models/onboarding_profile_hive_model.dart';
import '../models/scheduled_exercise_set_hive_model.dart';
import '../models/user_hive_model.dart';

/// Wraps all Hive box operations with typed read/write helpers.
@lazySingleton
class HiveDataSource {
  final Box<dynamic> _userBox;
  final Box<dynamic> _sessionBox;
  final Box<dynamic> _fallEventBox;
  final Box<dynamic> _badgeBox;
  final Box<dynamic> _onboardingBox;
  final Box<dynamic> _settingsBox;
  final Box<dynamic> _notificationBox;

  HiveDataSource(
    @Named('userBox') this._userBox,
    @Named('sessionBox') this._sessionBox,
    @Named('fallEventBox') this._fallEventBox,
    @Named('badgeBox') this._badgeBox,
    @Named('onboardingBox') this._onboardingBox,
    @Named('settingsBox') this._settingsBox,
    @Named('notificationBox') this._notificationBox,
  );

  // ---------------------------------------------------------------------------
  // User operations
  // ---------------------------------------------------------------------------

  Future<void> saveUser(UserHiveModel user) async =>
      _userBox.put(user.id, user);

  UserHiveModel? getUser(String id) => _userBox.get(id) as UserHiveModel?;

  List<UserHiveModel> getAllUsers() =>
      _userBox.values.cast<UserHiveModel>().toList();

  // ---------------------------------------------------------------------------
  // Session operations
  // ---------------------------------------------------------------------------

  Future<void> saveSession(ExerciseSessionHiveModel session) async =>
      _sessionBox.put(session.id, session);

  List<ExerciseSessionHiveModel> getAllSessions() =>
      _sessionBox.values.cast<ExerciseSessionHiveModel>().toList();

  Future<void> deleteSession(String id) async => _sessionBox.delete(id);

  // ---------------------------------------------------------------------------
  // Fall event operations
  // ---------------------------------------------------------------------------

  Future<void> saveFallEvent(FallEventHiveModel event) async =>
      _fallEventBox.put(event.id, event);

  List<FallEventHiveModel> getAllFallEvents() =>
      _fallEventBox.values.cast<FallEventHiveModel>().toList();

  Future<void> deleteFallEvent(String id) async => _fallEventBox.delete(id);

  // ---------------------------------------------------------------------------
  // Badge operations
  // ---------------------------------------------------------------------------

  Future<void> saveBadge(BadgeHiveModel badge) async =>
      _badgeBox.put(badge.id, badge);

  List<BadgeHiveModel> getAllBadges() =>
      _badgeBox.values.cast<BadgeHiveModel>().toList();

  // ---------------------------------------------------------------------------
  // Onboarding operations
  // ---------------------------------------------------------------------------

  Future<void> saveOnboardingProfile(
    String userId,
    OnboardingProfileHiveModel profile,
  ) async =>
      _onboardingBox.put(userId, profile);

  OnboardingProfileHiveModel? getOnboardingProfile(String userId) =>
      _onboardingBox.get(userId) as OnboardingProfileHiveModel?;

  // ---------------------------------------------------------------------------
  // Settings operations
  // ---------------------------------------------------------------------------

  Future<void> saveSetting(String key, dynamic value) async =>
      _settingsBox.put(key, value);

  T? getSetting<T>(String key) => _settingsBox.get(key) as T?;

  // ---------------------------------------------------------------------------
  // Notification flag operations
  // ---------------------------------------------------------------------------

  Future<void> setNotificationFlag(String key, bool value) async =>
      _notificationBox.put(key, value);

  bool getNotificationFlag(String key) =>
      (_notificationBox.get(key) as bool?) ?? false;

  // ---------------------------------------------------------------------------
  // Scheduled exercise set (per-day cache) operations
  // ---------------------------------------------------------------------------

  /// Returns the cached `exerciseIds` for `(userId, date)` if present, else
  /// `null`. Falls back to `null` when the schedule adapter (typeId 11) is not
  /// registered — callers should treat this as a cache miss and recompute.
  Future<List<String>?> getScheduleSet(String userId, DateTime date) async {
    if (!Hive.isAdapterRegistered(11)) return null;

    final box = Hive.box<ScheduledExerciseSetHiveModel>(
      AppConstants.hiveBoxSchedule,
    );
    final cached = box.get(_scheduleKey(userId, date));
    return cached?.exerciseIds;
  }

  /// Persists the deterministic schedule for `(userId, date)`. No-op when the
  /// schedule adapter (typeId 11) is not registered.
  Future<void> saveScheduleSet({
    required String userId,
    required DateTime date,
    required List<String> exerciseIds,
  }) async {
    if (!Hive.isAdapterRegistered(11)) return;

    final box = Hive.box<ScheduledExerciseSetHiveModel>(
      AppConstants.hiveBoxSchedule,
    );
    await box.put(
      _scheduleKey(userId, date),
      ScheduledExerciseSetHiveModel(
        userId: userId,
        date: date,
        exerciseIds: exerciseIds,
      ),
    );
  }

  String _scheduleKey(String userId, DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${userId}_$y$m$d';
  }
}


