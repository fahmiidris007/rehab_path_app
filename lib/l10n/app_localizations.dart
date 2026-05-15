import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'RehabPath'**
  String get appName;

  /// The full title of the application
  ///
  /// In en, this message translates to:
  /// **'RehabPath — Fall Prevention Rehabilitation'**
  String get appTitle;

  /// Tagline shown on the splash screen
  ///
  /// In en, this message translates to:
  /// **'Your journey to better balance starts here.'**
  String get authSplashTagline;

  /// Title on the welcome/onboarding carousel
  ///
  /// In en, this message translates to:
  /// **'Welcome to RehabPath'**
  String get authWelcomeTitle;

  /// Subtitle on the welcome screen
  ///
  /// In en, this message translates to:
  /// **'Evidence-based exercises to help you stay steady and confident.'**
  String get authWelcomeSubtitle;

  /// Title of the login page
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authLoginTitle;

  /// Hint text for the email field on login
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get authLoginEmailHint;

  /// Validation error for invalid email on login
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authLoginEmailError;

  /// Hint text for the password field on login
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authLoginPasswordHint;

  /// Validation error for invalid password on login
  ///
  /// In en, this message translates to:
  /// **'Password must be 8–64 characters.'**
  String get authLoginPasswordError;

  /// Label for the login button
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authLoginButton;

  /// Title of the registration page
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authRegisterTitle;

  /// Hint text for the name field on registration
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get authRegisterNameHint;

  /// Validation error for invalid name on registration
  ///
  /// In en, this message translates to:
  /// **'Name must be 1–50 characters.'**
  String get authRegisterNameError;

  /// Hint text for the email field on registration
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get authRegisterEmailHint;

  /// Validation error for invalid email on registration
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authRegisterEmailError;

  /// Hint text for the password field on registration
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authRegisterPasswordHint;

  /// Validation error for invalid password on registration
  ///
  /// In en, this message translates to:
  /// **'Password must be 8–64 characters.'**
  String get authRegisterPasswordError;

  /// Hint text for the confirm password field on registration
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authRegisterConfirmPasswordHint;

  /// Validation error when passwords do not match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get authRegisterConfirmPasswordError;

  /// Label for the register button
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authRegisterButton;

  /// Title of the forgot password page
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get authForgotPasswordTitle;

  /// Instructional message on the forgot password page
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we will send you a link to reset your password.'**
  String get authForgotPasswordMessage;

  /// Label for the send reset link button
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get authForgotPasswordButton;

  /// Label for the continue as guest button
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get authGuestButton;

  /// Banner message shown to guest users
  ///
  /// In en, this message translates to:
  /// **'You are browsing as a guest. Create an account to save your progress.'**
  String get authGuestBannerMessage;

  /// Label for the logout button
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get authLogoutButton;

  /// Title shown on the onboarding flow
  ///
  /// In en, this message translates to:
  /// **'Tell Us About Yourself'**
  String get onboardingTitle;

  /// Step indicator label during onboarding
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStepIndicator(int current, int total);

  /// Title for onboarding step 1
  ///
  /// In en, this message translates to:
  /// **'Age & Gender'**
  String get onboardingStep1Title;

  /// Title for onboarding step 2
  ///
  /// In en, this message translates to:
  /// **'Falls History'**
  String get onboardingStep2Title;

  /// Title for onboarding step 3
  ///
  /// In en, this message translates to:
  /// **'Health Conditions'**
  String get onboardingStep3Title;

  /// Title for onboarding step 4
  ///
  /// In en, this message translates to:
  /// **'Walking Aid'**
  String get onboardingStep4Title;

  /// Title for onboarding step 5
  ///
  /// In en, this message translates to:
  /// **'Fear of Falling'**
  String get onboardingStep5Title;

  /// Title for onboarding step 6
  ///
  /// In en, this message translates to:
  /// **'Exercise Preferences'**
  String get onboardingStep6Title;

  /// Title for onboarding step 7
  ///
  /// In en, this message translates to:
  /// **'Your Goals'**
  String get onboardingStep7Title;

  /// Label for the continue button during onboarding
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinueButton;

  /// Label for the back button during onboarding
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBackButton;

  /// Label for the finish button on the last onboarding step
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get onboardingFinishButton;

  /// Validation message when a required onboarding field is empty
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get onboardingValidationRequired;

  /// Morning greeting on the home dashboard
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingMorning;

  /// Afternoon greeting on the home dashboard
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGreetingAfternoon;

  /// Evening greeting on the home dashboard
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetingEvening;

  /// Streak days label on the home dashboard
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day streak} other{{count} day streak}}'**
  String homeStreakDays(num count);

  /// Section title for today's activity on the home dashboard
  ///
  /// In en, this message translates to:
  /// **'Today\'s Activity'**
  String get homeTodayActivity;

  /// Button label to start today's exercise
  ///
  /// In en, this message translates to:
  /// **'Start Exercise'**
  String get homeStartExercise;

  /// Message shown when no exercise program is assigned
  ///
  /// In en, this message translates to:
  /// **'No program assigned yet. Complete onboarding to get started.'**
  String get homeNoProgram;

  /// Section title for recommended exercises
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get homeRecommendedTitle;

  /// Label for total minutes stat on home dashboard
  ///
  /// In en, this message translates to:
  /// **'Total Minutes'**
  String get homeTotalMinutes;

  /// Label for total sessions stat on home dashboard
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get homeTotalSessions;

  /// Title of the exercise list page
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exerciseListTitle;

  /// Difficulty label on exercise cards
  ///
  /// In en, this message translates to:
  /// **'Difficulty: {level}'**
  String exerciseDifficulty(String level);

  /// Button label to start an exercise
  ///
  /// In en, this message translates to:
  /// **'Start Exercise'**
  String get exerciseStartButton;

  /// Button label to mark an exercise as complete
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete'**
  String get exerciseMarkComplete;

  /// Button label to pause an exercise
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get exercisePause;

  /// Button label to resume a paused exercise
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get exerciseResume;

  /// Button label to skip an exercise
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get exerciseSkip;

  /// Title of the self-report form after completing an exercise
  ///
  /// In en, this message translates to:
  /// **'How did it go?'**
  String get exerciseSelfReportTitle;

  /// Label for the body condition field in the self-report form
  ///
  /// In en, this message translates to:
  /// **'Body condition during exercise'**
  String get exerciseSelfReportBodyCondition;

  /// Option label for sitting body condition
  ///
  /// In en, this message translates to:
  /// **'Sitting'**
  String get exerciseSelfReportSitting;

  /// Option label for standing body condition
  ///
  /// In en, this message translates to:
  /// **'Standing'**
  String get exerciseSelfReportStanding;

  /// Label for the support used field in the self-report form
  ///
  /// In en, this message translates to:
  /// **'Support used'**
  String get exerciseSelfReportSupport;

  /// Option label for walking aid support
  ///
  /// In en, this message translates to:
  /// **'Walking aid'**
  String get exerciseSelfReportWalkingAid;

  /// Option label for kitchen worktop support
  ///
  /// In en, this message translates to:
  /// **'Kitchen worktop'**
  String get exerciseSelfReportKitchenWorktop;

  /// Option label for no support used
  ///
  /// In en, this message translates to:
  /// **'No support'**
  String get exerciseSelfReportNoSupport;

  /// Button label to submit the self-report form
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get exerciseSelfReportSubmit;

  /// Title of the progress page
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTitle;

  /// Label for weekly adherence metric on progress page
  ///
  /// In en, this message translates to:
  /// **'Weekly Adherence'**
  String get progressWeeklyAdherence;

  /// Label for monthly adherence metric on progress page
  ///
  /// In en, this message translates to:
  /// **'Monthly Adherence'**
  String get progressMonthlyAdherence;

  /// Label for balance score metric on progress page
  ///
  /// In en, this message translates to:
  /// **'Balance Score'**
  String get progressBalanceScore;

  /// Label for the falls diary section on progress page
  ///
  /// In en, this message translates to:
  /// **'Falls Diary'**
  String get progressFallsDiary;

  /// Label for the achievements section on progress page
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get progressAchievements;

  /// Label for the body areas trained section on progress page
  ///
  /// In en, this message translates to:
  /// **'Body Areas Trained'**
  String get progressBodyAreas;

  /// Message shown when no progress data is available
  ///
  /// In en, this message translates to:
  /// **'No data available yet. Complete exercises to see your progress.'**
  String get progressNoData;

  /// Title of the profile page
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// Button label to edit the user profile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditButton;

  /// Button label to update user goals
  ///
  /// In en, this message translates to:
  /// **'Update Goals'**
  String get profileUpdateGoals;

  /// Label for the program level field on the profile page
  ///
  /// In en, this message translates to:
  /// **'Program Level'**
  String get profileProgramLevel;

  /// Label for the health conditions field on the profile page
  ///
  /// In en, this message translates to:
  /// **'Health Conditions'**
  String get profileHealthConditions;

  /// Label for the goals field on the profile page
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get profileGoals;

  /// Title of the settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Section header for appearance settings
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// Label for the theme setting
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// Option label for light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// Option label for dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// Option label for system default theme
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsThemeSystem;

  /// Label for the language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Option label for English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// Option label for Indonesian language
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get settingsLanguageId;

  /// Label for the font size setting
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get settingsFontSize;

  /// Option label for default font size
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get settingsFontSizeDefault;

  /// Option label for large font size
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get settingsFontSizeLarge;

  /// Option label for extra large font size
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get settingsFontSizeExtraLarge;

  /// Section header for notification settings
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// Label for the daily reminder toggle in settings
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get settingsDailyReminder;

  /// Label for the privacy policy link in settings
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// Label for the terms of service link in settings
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTermsOfService;

  /// Label for the logout option in settings
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get settingsLogout;

  /// Title of the SOS page
  ///
  /// In en, this message translates to:
  /// **'Emergency SOS'**
  String get sosTitle;

  /// Safety reminder message on the SOS page
  ///
  /// In en, this message translates to:
  /// **'If you have fallen and cannot get up, call emergency services immediately.'**
  String get sosSafetyReminder;

  /// Button label to call an emergency contact
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get sosCallButton;

  /// Message shown when no emergency contacts are set
  ///
  /// In en, this message translates to:
  /// **'No emergency contacts added. Please update your profile.'**
  String get sosNoContacts;

  /// Button label to call emergency services
  ///
  /// In en, this message translates to:
  /// **'Call Emergency Services'**
  String get sosEmergencyButton;

  /// Title of the daily reminder notification
  ///
  /// In en, this message translates to:
  /// **'Time to Exercise!'**
  String get notificationDailyReminderTitle;

  /// Body text of the daily reminder notification
  ///
  /// In en, this message translates to:
  /// **'Your daily rehabilitation session is ready. Keep up the great work!'**
  String get notificationDailyReminderBody;

  /// Title of the streak milestone notification
  ///
  /// In en, this message translates to:
  /// **'Streak Milestone!'**
  String get notificationStreakTitle;

  /// Body text of the streak milestone notification
  ///
  /// In en, this message translates to:
  /// **'Amazing! You have kept a {days}-day exercise streak. Keep it up!'**
  String notificationStreakBody(int days);

  /// Title of the re-engagement notification
  ///
  /// In en, this message translates to:
  /// **'We Miss You!'**
  String get notificationReEngagementTitle;

  /// Body text of the re-engagement notification
  ///
  /// In en, this message translates to:
  /// **'It has been a while since your last session. Come back and continue your progress!'**
  String get notificationReEngagementBody;

  /// Title of the weekly summary notification
  ///
  /// In en, this message translates to:
  /// **'Weekly Summary'**
  String get notificationWeeklySummaryTitle;

  /// Body text of the weekly summary notification
  ///
  /// In en, this message translates to:
  /// **'You completed {rate}% of your exercises this week. Great effort!'**
  String notificationWeeklySummaryBody(int rate);

  /// Message shown when notification permission is denied
  ///
  /// In en, this message translates to:
  /// **'Notification permission was denied. Enable notifications in your device settings to receive reminders.'**
  String get notificationPermissionDeniedMessage;

  /// Generic server error message
  ///
  /// In en, this message translates to:
  /// **'A server error occurred. Please try again later.'**
  String get errorServer;

  /// Cache/local storage error message
  ///
  /// In en, this message translates to:
  /// **'Could not load data from local storage. Please restart the app.'**
  String get errorCache;

  /// Generic unexpected error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorUnexpected;

  /// Error message when data seeding fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load initial data. Please restart the app.'**
  String get errorSeedingFailed;

  /// Error message when phone calls are not supported
  ///
  /// In en, this message translates to:
  /// **'Phone calls are not supported on this device.'**
  String get errorPhoneNotSupported;

  /// Error message when saving profile fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile. Please try again.'**
  String get errorSaveProfile;

  /// Generic error message when loading data fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load data. Please try again.'**
  String get errorLoadData;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
