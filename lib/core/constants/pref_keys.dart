/// SharedPreferences key constants used throughout the app.
class PrefKeys {
  PrefKeys._();

  // Session
  static const String sessionToken = 'session_token';
  static const String sessionUserId = 'session_user_id';
  static const String isGuest = 'is_guest';

  // Seeding / Onboarding
  static const String seedingComplete = 'seeding_complete';
  static const String onboardingComplete = 'onboarding_complete';

  // Appearance
  static const String themeMode = 'theme_mode';
  static const String locale = 'locale';
  static const String fontSizeLevel = 'font_size_level';

  // Notifications
  static const String notificationsEnabled = 'notifications_enabled';

  // Streak milestone notification flags
  static const String streakMilestone3 = 'streak_milestone_3_sent';
  static const String streakMilestone7 = 'streak_milestone_7_sent';
  static const String streakMilestone14 = 'streak_milestone_14_sent';
  static const String streakMilestone30 = 'streak_milestone_30_sent';
}
