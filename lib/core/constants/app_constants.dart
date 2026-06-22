/// App-wide constants that don't belong to a specific feature.
class AppConstants {
  AppConstants._();

  // App identity
  static const String appName = 'Laman Lansia';
  static const String appVersion = '0.1.0';

  // Splash screen minimum display duration (milliseconds)
  static const int splashMinDurationMs = 1500;

  // Onboarding
  static const int onboardingTotalSteps = 7;

  // Exercise player
  static const int countdownWarningThresholdSeconds = 10;

  // Streak
  static const List<int> streakMilestoneDays = [3, 7, 14, 30];

  // Balance score range (Berg Balance Scale)
  static const int balanceScoreMin = 0;
  static const int balanceScoreMax = 56;

  // Fear of falling score range
  static const int fearOfFallingMin = 1;
  static const int fearOfFallingMax = 5;

  // Tap debounce duration (milliseconds)
  static const int navigationDebounceDurationMs = 300;

  // Font size multipliers
  static const double fontSizeMultiplierDefault = 1.0;
  static const double fontSizeMultiplierLarge = 1.25;
  static const double fontSizeMultiplierExtraLarge = 1.5;

  // Hive box names
  static const String hiveBoxUser = 'userBox';
  static const String hiveBoxSession = 'sessionBox';
  static const String hiveBoxFallEvent = 'fallEventBox';
  static const String hiveBoxBadge = 'badgeBox';
  static const String hiveBoxOnboarding = 'onboardingBox';
  static const String hiveBoxSettings = 'settingsBox';
  static const String hiveBoxNotification = 'notificationBox';
  static const String hiveBoxSchedule = 'scheduleBox';

  // Asset paths
  static const String assetDummyUsers = 'assets/data/dummy_users.json';
  static const String assetDummyExercises = 'assets/data/dummy_exercises.json';
  static const String assetDummyPrograms = 'assets/data/dummy_programs.json';
  static const String assetDummyProgress = 'assets/data/dummy_progress.json';
  static const String assetDummyMessages = 'assets/data/dummy_messages.json';

  // Exercise demo videos
  //
  // NOTE: These are placeholder sample clips reused for every exercise while
  // the app runs offline-first with no backend. Once a media service is wired
  // in, each [ExerciseEntity] should expose its own video URL/path and these
  // shared constants can be removed.
  static const String assetExerciseDetailVideo =
      'assets/videos/exercise_demo_detail.mp4';
  static const String assetExercisePlayerVideo =
      'assets/videos/exercise_demo_player.mp4';

  /// While there is no per-exercise video duration metadata, the player runs
  /// for this many loops of the demo clip before auto-saving the session.
  static const int exercisePlayerVideoLoopCount = 3;
}
