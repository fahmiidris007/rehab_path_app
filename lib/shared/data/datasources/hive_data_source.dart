import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../models/badge_hive_model.dart';
import '../models/exercise_session_hive_model.dart';
import '../models/fall_event_hive_model.dart';
import '../models/onboarding_profile_hive_model.dart';
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
}


