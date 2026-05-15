// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'RehabPath';

  @override
  String get appTitle => 'RehabPath — Fall Prevention Rehabilitation';

  @override
  String get authSplashTagline => 'Your journey to better balance starts here.';

  @override
  String get authWelcomeTitle => 'Welcome to RehabPath';

  @override
  String get authWelcomeSubtitle =>
      'Evidence-based exercises to help you stay steady and confident.';

  @override
  String get authLoginTitle => 'Log In';

  @override
  String get authLoginEmailHint => 'Email address';

  @override
  String get authLoginEmailError => 'Please enter a valid email address.';

  @override
  String get authLoginPasswordHint => 'Password';

  @override
  String get authLoginPasswordError => 'Password must be 8–64 characters.';

  @override
  String get authLoginButton => 'Log In';

  @override
  String get authRegisterTitle => 'Create Account';

  @override
  String get authRegisterNameHint => 'Full name';

  @override
  String get authRegisterNameError => 'Name must be 1–50 characters.';

  @override
  String get authRegisterEmailHint => 'Email address';

  @override
  String get authRegisterEmailError => 'Please enter a valid email address.';

  @override
  String get authRegisterPasswordHint => 'Password';

  @override
  String get authRegisterPasswordError => 'Password must be 8–64 characters.';

  @override
  String get authRegisterConfirmPasswordHint => 'Confirm password';

  @override
  String get authRegisterConfirmPasswordError => 'Passwords do not match.';

  @override
  String get authRegisterButton => 'Create Account';

  @override
  String get authForgotPasswordTitle => 'Forgot Password';

  @override
  String get authForgotPasswordMessage =>
      'Enter your email address and we will send you a link to reset your password.';

  @override
  String get authForgotPasswordButton => 'Send Reset Link';

  @override
  String get authGuestButton => 'Continue as Guest';

  @override
  String get authGuestBannerMessage =>
      'You are browsing as a guest. Create an account to save your progress.';

  @override
  String get authLogoutButton => 'Log Out';

  @override
  String get onboardingTitle => 'Tell Us About Yourself';

  @override
  String onboardingStepIndicator(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get onboardingStep1Title => 'Age & Gender';

  @override
  String get onboardingStep2Title => 'Falls History';

  @override
  String get onboardingStep3Title => 'Health Conditions';

  @override
  String get onboardingStep4Title => 'Walking Aid';

  @override
  String get onboardingStep5Title => 'Fear of Falling';

  @override
  String get onboardingStep6Title => 'Exercise Preferences';

  @override
  String get onboardingStep7Title => 'Your Goals';

  @override
  String get onboardingContinueButton => 'Continue';

  @override
  String get onboardingBackButton => 'Back';

  @override
  String get onboardingFinishButton => 'Finish';

  @override
  String get onboardingValidationRequired => 'This field is required.';

  @override
  String get homeGreetingMorning => 'Good morning';

  @override
  String get homeGreetingAfternoon => 'Good afternoon';

  @override
  String get homeGreetingEvening => 'Good evening';

  @override
  String homeStreakDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString day streak',
      one: '1 day streak',
    );
    return '$_temp0';
  }

  @override
  String get homeTodayActivity => 'Today\'s Activity';

  @override
  String get homeStartExercise => 'Start Exercise';

  @override
  String get homeNoProgram =>
      'No program assigned yet. Complete onboarding to get started.';

  @override
  String get homeRecommendedTitle => 'Recommended for You';

  @override
  String get homeTotalMinutes => 'Total Minutes';

  @override
  String get homeTotalSessions => 'Total Sessions';

  @override
  String get exerciseListTitle => 'Exercises';

  @override
  String exerciseDifficulty(String level) {
    return 'Difficulty: $level';
  }

  @override
  String get exerciseStartButton => 'Start Exercise';

  @override
  String get exerciseMarkComplete => 'Mark as Complete';

  @override
  String get exercisePause => 'Pause';

  @override
  String get exerciseResume => 'Resume';

  @override
  String get exerciseSkip => 'Skip';

  @override
  String get exerciseSelfReportTitle => 'How did it go?';

  @override
  String get exerciseSelfReportBodyCondition =>
      'Body condition during exercise';

  @override
  String get exerciseSelfReportSitting => 'Sitting';

  @override
  String get exerciseSelfReportStanding => 'Standing';

  @override
  String get exerciseSelfReportSupport => 'Support used';

  @override
  String get exerciseSelfReportWalkingAid => 'Walking aid';

  @override
  String get exerciseSelfReportKitchenWorktop => 'Kitchen worktop';

  @override
  String get exerciseSelfReportNoSupport => 'No support';

  @override
  String get exerciseSelfReportSubmit => 'Submit';

  @override
  String get progressTitle => 'Progress';

  @override
  String get progressWeeklyAdherence => 'Weekly Adherence';

  @override
  String get progressMonthlyAdherence => 'Monthly Adherence';

  @override
  String get progressBalanceScore => 'Balance Score';

  @override
  String get progressFallsDiary => 'Falls Diary';

  @override
  String get progressAchievements => 'Achievements';

  @override
  String get progressBodyAreas => 'Body Areas Trained';

  @override
  String get progressNoData =>
      'No data available yet. Complete exercises to see your progress.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEditButton => 'Edit Profile';

  @override
  String get profileUpdateGoals => 'Update Goals';

  @override
  String get profileProgramLevel => 'Program Level';

  @override
  String get profileHealthConditions => 'Health Conditions';

  @override
  String get profileGoals => 'Goals';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System default';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsLanguageId => 'Indonesian';

  @override
  String get settingsFontSize => 'Font Size';

  @override
  String get settingsFontSizeDefault => 'Default';

  @override
  String get settingsFontSizeLarge => 'Large';

  @override
  String get settingsFontSizeExtraLarge => 'Extra Large';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsDailyReminder => 'Daily Reminder';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTermsOfService => 'Terms of Service';

  @override
  String get settingsLogout => 'Log Out';

  @override
  String get sosTitle => 'Emergency SOS';

  @override
  String get sosSafetyReminder =>
      'If you have fallen and cannot get up, call emergency services immediately.';

  @override
  String get sosCallButton => 'Call';

  @override
  String get sosNoContacts =>
      'No emergency contacts added. Please update your profile.';

  @override
  String get sosEmergencyButton => 'Call Emergency Services';

  @override
  String get notificationDailyReminderTitle => 'Time to Exercise!';

  @override
  String get notificationDailyReminderBody =>
      'Your daily rehabilitation session is ready. Keep up the great work!';

  @override
  String get notificationStreakTitle => 'Streak Milestone!';

  @override
  String notificationStreakBody(int days) {
    return 'Amazing! You have kept a $days-day exercise streak. Keep it up!';
  }

  @override
  String get notificationReEngagementTitle => 'We Miss You!';

  @override
  String get notificationReEngagementBody =>
      'It has been a while since your last session. Come back and continue your progress!';

  @override
  String get notificationWeeklySummaryTitle => 'Weekly Summary';

  @override
  String notificationWeeklySummaryBody(int rate) {
    return 'You completed $rate% of your exercises this week. Great effort!';
  }

  @override
  String get notificationPermissionDeniedMessage =>
      'Notification permission was denied. Enable notifications in your device settings to receive reminders.';

  @override
  String get errorServer => 'A server error occurred. Please try again later.';

  @override
  String get errorCache =>
      'Could not load data from local storage. Please restart the app.';

  @override
  String get errorUnexpected =>
      'An unexpected error occurred. Please try again.';

  @override
  String get errorSeedingFailed =>
      'Failed to load initial data. Please restart the app.';

  @override
  String get errorPhoneNotSupported =>
      'Phone calls are not supported on this device.';

  @override
  String get errorSaveProfile => 'Failed to save profile. Please try again.';

  @override
  String get errorLoadData => 'Failed to load data. Please try again.';
}
