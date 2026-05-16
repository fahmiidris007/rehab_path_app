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

  @override
  String get navHome => 'Home';

  @override
  String get navExercise => 'Exercise';

  @override
  String get navProgress => 'Progress';

  @override
  String get navProfile => 'Profile';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get authLoginNoAccount => 'Don\'t have an account?';

  @override
  String get authLoginRegisterLink => 'Register';

  @override
  String get authLoginForgotPassword => 'Forgot Password?';

  @override
  String get authRegisterHaveAccount => 'Already have an account?';

  @override
  String get authRegisterLoginLink => 'Log In';

  @override
  String get authRegisterSuccessMessage =>
      'Account created! Please log in to continue.';

  @override
  String get authForgotPasswordResetSent => 'Reset link sent!';

  @override
  String get authForgotPasswordResetBody =>
      'Check your email for a link to reset your password. If it doesn\'t appear within a few minutes, check your spam folder.';

  @override
  String get authForgotPasswordBackToLogin => 'Back to Log In';

  @override
  String get welcomeGetStarted => 'Get Started';

  @override
  String get welcomeSlide1Title => 'Stay Steady';

  @override
  String get welcomeSlide1Subtitle =>
      'Build confidence and reduce your risk of falls with guided balance exercises designed for you.';

  @override
  String get welcomeSlide2Title => 'Exercise Daily';

  @override
  String get welcomeSlide2Subtitle =>
      'Follow evidence-based FaME and Otago programs tailored to your fitness level and goals.';

  @override
  String get welcomeSlide3Title => 'Track Progress';

  @override
  String get welcomeSlide3Subtitle =>
      'Monitor your improvement over time and celebrate milestones on your rehabilitation journey.';

  @override
  String get homeNoExercisesToday => 'No exercises today';

  @override
  String get homeRestDayMessage =>
      'Enjoy your rest day or browse recommended exercises below.';

  @override
  String get homeNoRecommendations => 'No recommendations available.';

  @override
  String get homeRecommendedFor => 'Recommended for You';

  @override
  String get homeTodayWorkout => 'Today\'s Workout';

  @override
  String get homeExerciseSingular => 'Exercise';

  @override
  String get homeExercisePlural => 'Exercises';

  @override
  String get homeMinutes => 'Minutes';

  @override
  String get homeDone => 'Done';

  @override
  String get homeAllDoneToday => 'All Done Today 🎉';

  @override
  String homeContinueLeft(int remaining) {
    return 'Continue ($remaining left)';
  }

  @override
  String get homeStatMinutes => 'Minutes';

  @override
  String get homeStatSessions => 'Sessions';

  @override
  String get homeStatDayStreak => 'Day Streak';

  @override
  String get homeGuestBannerMessage =>
      'You are in Guest mode. Register or log in to save your progress.';

  @override
  String get guestBannerRegister => 'Register';

  @override
  String get exerciseCompletedToday => 'Completed today';

  @override
  String get exerciseRedoButton => 'Redo Exercise';

  @override
  String get exerciseCouldNotLoad => 'Could not load exercise';

  @override
  String get exerciseDifficultyLabel => 'Difficulty';

  @override
  String get exerciseHowToDoIt => 'How to do it';

  @override
  String get exerciseSafetyTips => 'Safety Tips';

  @override
  String exerciseNext(String name) {
    return 'Next: $name';
  }

  @override
  String exerciseDurationMin(int duration) {
    return '$duration min';
  }

  @override
  String exerciseSets(int sets) {
    return '$sets sets';
  }

  @override
  String exerciseReps(int reps) {
    return '$reps reps';
  }

  @override
  String get exerciseDifficultyEasy => 'Easy';

  @override
  String get exerciseDifficultyMedium => 'Medium';

  @override
  String get exerciseDifficultyHard => 'Hard';

  @override
  String get exercisePlayerPaused => 'Paused';

  @override
  String get exerciseSomethingWentWrong => 'Something went wrong';

  @override
  String get exerciseNoExercisesYet => 'No exercises yet';

  @override
  String get exerciseCheckBackSoon =>
      'Check back soon for your personalised programme.';

  @override
  String get exerciseCategoryWarmUp => 'Warm Up';

  @override
  String get exerciseCategoryBalanceTraining => 'Balance Training';

  @override
  String get exerciseCategoryStrengthTraining => 'Strength Training';

  @override
  String get exerciseCategoryEnduranceAerobic => 'Endurance / Aerobic';

  @override
  String get exerciseCategoryTaiChi => 'Tai Chi';

  @override
  String get exerciseCategoryWalkingProgram => 'Walking Program';

  @override
  String get exerciseCategoryGettingUpFromFloor => 'Getting Up From Floor';

  @override
  String get exerciseCategoryCoolDown => 'Cool Down';

  @override
  String get exerciseSelfReportBodyPosition => 'Body position';

  @override
  String get progressMyProgress => 'My Progress';

  @override
  String get progressAdherence => 'Adherence';

  @override
  String get progressThisWeek => 'This Week';

  @override
  String get progressThisMonth => 'This Month';

  @override
  String get progressNoDataYet => 'No data yet';

  @override
  String get progressCompleteExercises =>
      'Complete exercises to see your progress.';

  @override
  String get progressBalanceScoreTrend => 'Balance Score Trend';

  @override
  String get progressNoBalanceData => 'No balance data yet';

  @override
  String get progressCompleteAssessments =>
      'Complete balance assessments to track your trend.';

  @override
  String get progressFallRecorded => 'Fall recorded — tap to remove';

  @override
  String get progressNoBadgesYet => 'No badges yet';

  @override
  String get progressKeepExercising =>
      'Keep exercising to earn your first badge!';

  @override
  String get progressBodyAreasThisWeek => 'Body Areas Worked This Week';

  @override
  String get progressNoAreasTracked => 'No areas tracked yet';

  @override
  String get progressCompleteThisWeek =>
      'Complete exercises this week to see which muscle groups you\'ve worked.';

  @override
  String profileYearsOld(int age) {
    return '$age years old';
  }

  @override
  String get profileProgramLevelBeginner => 'Beginner';

  @override
  String get profileProgramLevelIntermediate => 'Intermediate';

  @override
  String get profileProgramLevelAdvanced => 'Advanced';

  @override
  String get profileOutcomeGoal => 'Outcome Goal';

  @override
  String get profileBehaviouralGoal => 'Behavioural Goal';

  @override
  String get profileEmergencyContacts => 'Emergency Contacts';

  @override
  String get profileLogOut => 'Log Out';

  @override
  String get profileLogOutConfirmTitle => 'Log Out';

  @override
  String get profileLogOutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get profileLogOutConfirmCancel => 'Cancel';

  @override
  String get profileLogOutConfirmButton => 'Log Out';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfileFullName => 'Full Name';

  @override
  String get editProfileNameHint => 'Enter your full name';

  @override
  String get editProfileNameEmpty => 'Name cannot be empty';

  @override
  String get editProfileSave => 'Save';

  @override
  String get editProfileFailedToUpdate =>
      'Failed to update profile. Please try again.';

  @override
  String get settingsVoiceCues => 'Voice Cues';

  @override
  String get settingsVoiceCuesSubtitle => 'Play audio prompts during exercises';

  @override
  String get settingsDailyReminderSubtitle =>
      'Receive a daily reminder to complete your exercises';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsNotificationPermissionDeniedTitle =>
      'Notification Permission Denied';

  @override
  String get settingsNotificationPermissionDeniedMessage =>
      'Notification permission was denied. Please enable notifications in your device settings to receive reminders.';

  @override
  String get sosNoEmergencyContacts => 'No emergency contacts';

  @override
  String get sosAddContactsMessage =>
      'Add emergency contacts in your profile to use this feature.';

  @override
  String get sosCallingNotSupported =>
      'Calling is not supported on this device.';

  @override
  String get sosSafetyReminderFull =>
      'If you have fallen and cannot get up, remain calm and stay on the floor until help arrives. Call emergency services or a contact below.';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get loadingDashboard => 'Loading dashboard…';

  @override
  String get onboardingStep4Question => 'Do you use a walking aid?';

  @override
  String get onboardingYes => 'Yes';

  @override
  String get onboardingNo => 'No';
}
