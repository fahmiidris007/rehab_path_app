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
  /// **'Password must be at least 8 characters.'**
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
  /// **'Password must be at least 8 characters.'**
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

  /// FAB label to add a new emergency contact
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get sosAddContact;

  /// Title of the add contact bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Add Emergency Contact'**
  String get sosAddContactTitle;

  /// Title of the edit contact bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Edit Emergency Contact'**
  String get sosEditContactTitle;

  /// Menu item label to edit a contact
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get sosEditContact;

  /// Menu item label to delete a contact
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get sosDeleteContact;

  /// Title of the delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Contact'**
  String get sosDeleteContactTitle;

  /// Body of the delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from your emergency contacts?'**
  String sosDeleteContactMessage(String name);

  /// Button label to save a contact in the bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Save Contact'**
  String get sosSaveContact;

  /// Label for the name field in the contact form
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sosContactName;

  /// Hint for the name field in the contact form
  ///
  /// In en, this message translates to:
  /// **'e.g. John Smith'**
  String get sosContactNameHint;

  /// Validation error when name is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a name.'**
  String get sosContactNameRequired;

  /// Label for the relationship field in the contact form
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get sosContactRelationship;

  /// Hint for the relationship field in the contact form
  ///
  /// In en, this message translates to:
  /// **'e.g. Son, Daughter, Neighbour'**
  String get sosContactRelationshipHint;

  /// Validation error when relationship is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter the relationship.'**
  String get sosContactRelationshipRequired;

  /// Label for the phone field in the contact form
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get sosContactPhone;

  /// Hint for the phone field in the contact form
  ///
  /// In en, this message translates to:
  /// **'e.g. +62 812 3456 7890'**
  String get sosContactPhoneHint;

  /// Validation error when phone is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a phone number.'**
  String get sosContactPhoneRequired;

  /// Validation error when phone number is too short
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number.'**
  String get sosContactPhoneInvalid;

  /// Subtitle on the empty state when no contacts exist
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to add your first emergency contact.'**
  String get sosAddContactsPrompt;

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

  /// Bottom nav label for Home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom nav label for Exercise tab
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get navExercise;

  /// Bottom nav label for Progress tab
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// Bottom nav label for Profile tab
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Label for language selector on login page
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Text before register link on login page
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authLoginNoAccount;

  /// Register link text on login page
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authLoginRegisterLink;

  /// Forgot password link on login page
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authLoginForgotPassword;

  /// Text before login link on register page
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authRegisterHaveAccount;

  /// Log in link text on register page
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authRegisterLoginLink;

  /// Success message after registration
  ///
  /// In en, this message translates to:
  /// **'Account created! Please log in to continue.'**
  String get authRegisterSuccessMessage;

  /// Title shown after reset link is sent
  ///
  /// In en, this message translates to:
  /// **'Reset link sent!'**
  String get authForgotPasswordResetSent;

  /// Body text after reset link is sent
  ///
  /// In en, this message translates to:
  /// **'Check your email for a link to reset your password. If it doesn\'t appear within a few minutes, check your spam folder.'**
  String get authForgotPasswordResetBody;

  /// Back to login link on forgot password page
  ///
  /// In en, this message translates to:
  /// **'Back to Log In'**
  String get authForgotPasswordBackToLogin;

  /// Get started button on welcome page
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get welcomeGetStarted;

  /// Title of first welcome slide
  ///
  /// In en, this message translates to:
  /// **'Stay Steady'**
  String get welcomeSlide1Title;

  /// Subtitle of first welcome slide
  ///
  /// In en, this message translates to:
  /// **'Build confidence and reduce your risk of falls with guided balance exercises designed for you.'**
  String get welcomeSlide1Subtitle;

  /// Title of second welcome slide
  ///
  /// In en, this message translates to:
  /// **'Exercise Daily'**
  String get welcomeSlide2Title;

  /// Subtitle of second welcome slide
  ///
  /// In en, this message translates to:
  /// **'Follow evidence-based FaME and Otago programs tailored to your fitness level and goals.'**
  String get welcomeSlide2Subtitle;

  /// Title of third welcome slide
  ///
  /// In en, this message translates to:
  /// **'Track Progress'**
  String get welcomeSlide3Title;

  /// Subtitle of third welcome slide
  ///
  /// In en, this message translates to:
  /// **'Monitor your improvement over time and celebrate milestones on your rehabilitation journey.'**
  String get welcomeSlide3Subtitle;

  /// Title when no exercises scheduled today
  ///
  /// In en, this message translates to:
  /// **'No exercises today'**
  String get homeNoExercisesToday;

  /// Message on rest day
  ///
  /// In en, this message translates to:
  /// **'Enjoy your rest day or browse recommended exercises below.'**
  String get homeRestDayMessage;

  /// Message when no recommendations
  ///
  /// In en, this message translates to:
  /// **'No recommendations available.'**
  String get homeNoRecommendations;

  /// Section title for recommended exercises
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get homeRecommendedFor;

  /// Title of today's workout card
  ///
  /// In en, this message translates to:
  /// **'Today\'s Workout'**
  String get homeTodayWorkout;

  /// Singular label for exercise count
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get homeExerciseSingular;

  /// Plural label for exercise count
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get homeExercisePlural;

  /// Minutes label in workout card
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get homeMinutes;

  /// Done label in workout card
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get homeDone;

  /// Button label when all exercises done
  ///
  /// In en, this message translates to:
  /// **'All Done Today 🎉'**
  String get homeAllDoneToday;

  /// Continue button with remaining count
  ///
  /// In en, this message translates to:
  /// **'Continue ({remaining} left)'**
  String homeContinueLeft(int remaining);

  /// Minutes stat label in quick stats row
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get homeStatMinutes;

  /// Sessions stat label in quick stats row
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get homeStatSessions;

  /// Day streak stat label in quick stats row
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get homeStatDayStreak;

  /// Short days label in quick stats row
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get homeStatDays;

  /// Guest banner message on home page
  ///
  /// In en, this message translates to:
  /// **'You are in Guest mode. Register or log in to save your progress.'**
  String get homeGuestBannerMessage;

  /// Register button in guest banner
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get guestBannerRegister;

  /// Badge shown when exercise is completed today
  ///
  /// In en, this message translates to:
  /// **'Completed today'**
  String get exerciseCompletedToday;

  /// Button to redo a completed exercise
  ///
  /// In en, this message translates to:
  /// **'Redo Exercise'**
  String get exerciseRedoButton;

  /// Error title when exercise cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load exercise'**
  String get exerciseCouldNotLoad;

  /// Section label for difficulty
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get exerciseDifficultyLabel;

  /// Section label for exercise steps
  ///
  /// In en, this message translates to:
  /// **'How to do it'**
  String get exerciseHowToDoIt;

  /// Section label for safety tips
  ///
  /// In en, this message translates to:
  /// **'Safety Tips'**
  String get exerciseSafetyTips;

  /// Next exercise button label
  ///
  /// In en, this message translates to:
  /// **'Next: {name}'**
  String exerciseNext(String name);

  /// Duration in minutes
  ///
  /// In en, this message translates to:
  /// **'{duration} min'**
  String exerciseDurationMin(int duration);

  /// Sets count
  ///
  /// In en, this message translates to:
  /// **'{sets} sets'**
  String exerciseSets(int sets);

  /// Reps count
  ///
  /// In en, this message translates to:
  /// **'{reps} reps'**
  String exerciseReps(int reps);

  /// Easy difficulty label
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get exerciseDifficultyEasy;

  /// Medium difficulty label
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get exerciseDifficultyMedium;

  /// Hard difficulty label
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get exerciseDifficultyHard;

  /// Paused label in exercise player
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get exercisePlayerPaused;

  /// Error title in exercise list
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get exerciseSomethingWentWrong;

  /// Empty state title in exercise list
  ///
  /// In en, this message translates to:
  /// **'No exercises yet'**
  String get exerciseNoExercisesYet;

  /// Empty state subtitle in exercise list
  ///
  /// In en, this message translates to:
  /// **'Check back soon for your personalised programme.'**
  String get exerciseCheckBackSoon;

  /// Exercise category: Warm Up
  ///
  /// In en, this message translates to:
  /// **'Warm Up'**
  String get exerciseCategoryWarmUp;

  /// Exercise category: Balance Training
  ///
  /// In en, this message translates to:
  /// **'Balance Training'**
  String get exerciseCategoryBalanceTraining;

  /// Exercise category: Strength Training
  ///
  /// In en, this message translates to:
  /// **'Strength Training'**
  String get exerciseCategoryStrengthTraining;

  /// Exercise category: Endurance / Aerobic
  ///
  /// In en, this message translates to:
  /// **'Endurance / Aerobic'**
  String get exerciseCategoryEnduranceAerobic;

  /// Exercise category: Tai Chi
  ///
  /// In en, this message translates to:
  /// **'Tai Chi'**
  String get exerciseCategoryTaiChi;

  /// Exercise category: Walking Program
  ///
  /// In en, this message translates to:
  /// **'Walking Program'**
  String get exerciseCategoryWalkingProgram;

  /// Exercise category: Getting Up From Floor
  ///
  /// In en, this message translates to:
  /// **'Getting Up From Floor'**
  String get exerciseCategoryGettingUpFromFloor;

  /// Exercise category: Cool Down
  ///
  /// In en, this message translates to:
  /// **'Cool Down'**
  String get exerciseCategoryCoolDown;

  /// Body position label in self report
  ///
  /// In en, this message translates to:
  /// **'Body position'**
  String get exerciseSelfReportBodyPosition;

  /// Title of progress page
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get progressMyProgress;

  /// Adherence section title
  ///
  /// In en, this message translates to:
  /// **'Adherence'**
  String get progressAdherence;

  /// This week label
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get progressThisWeek;

  /// This month label
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get progressThisMonth;

  /// No data yet title
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get progressNoDataYet;

  /// Complete exercises subtitle
  ///
  /// In en, this message translates to:
  /// **'Complete exercises to see your progress.'**
  String get progressCompleteExercises;

  /// Balance score trend section title
  ///
  /// In en, this message translates to:
  /// **'Balance Score Trend'**
  String get progressBalanceScoreTrend;

  /// No balance data title
  ///
  /// In en, this message translates to:
  /// **'No balance data yet'**
  String get progressNoBalanceData;

  /// Complete assessments subtitle
  ///
  /// In en, this message translates to:
  /// **'Complete balance assessments to track your trend.'**
  String get progressCompleteAssessments;

  /// Fall recorded legend text
  ///
  /// In en, this message translates to:
  /// **'Fall recorded — tap to remove'**
  String get progressFallRecorded;

  /// No badges yet title
  ///
  /// In en, this message translates to:
  /// **'No badges yet'**
  String get progressNoBadgesYet;

  /// Keep exercising subtitle
  ///
  /// In en, this message translates to:
  /// **'Keep exercising to earn your first badge!'**
  String get progressKeepExercising;

  /// Body areas section title
  ///
  /// In en, this message translates to:
  /// **'Body Areas Worked This Week'**
  String get progressBodyAreasThisWeek;

  /// No areas tracked title
  ///
  /// In en, this message translates to:
  /// **'No areas tracked yet'**
  String get progressNoAreasTracked;

  /// Complete this week subtitle
  ///
  /// In en, this message translates to:
  /// **'Complete exercises this week to see which muscle groups you\'ve worked.'**
  String get progressCompleteThisWeek;

  /// Age display on profile page
  ///
  /// In en, this message translates to:
  /// **'{age} years old'**
  String profileYearsOld(int age);

  /// Beginner program level
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get profileProgramLevelBeginner;

  /// Intermediate program level
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get profileProgramLevelIntermediate;

  /// Advanced program level
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get profileProgramLevelAdvanced;

  /// Outcome goal label on profile
  ///
  /// In en, this message translates to:
  /// **'Outcome Goal'**
  String get profileOutcomeGoal;

  /// Behavioural goal label on profile
  ///
  /// In en, this message translates to:
  /// **'Behavioural Goal'**
  String get profileBehaviouralGoal;

  /// Emergency contacts button label
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get profileEmergencyContacts;

  /// Log out option on profile page
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogOut;

  /// Log out confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogOutConfirmTitle;

  /// Log out confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get profileLogOutConfirmMessage;

  /// Cancel button in log out dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileLogOutConfirmCancel;

  /// Confirm log out button
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogOutConfirmButton;

  /// Title of edit profile page
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// Full name label on edit profile
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get editProfileFullName;

  /// Name field hint on edit profile
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get editProfileNameHint;

  /// Validation error when name is empty
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get editProfileNameEmpty;

  /// Save button on edit profile
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editProfileSave;

  /// Error message when profile update fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile. Please try again.'**
  String get editProfileFailedToUpdate;

  /// Voice cues setting label
  ///
  /// In en, this message translates to:
  /// **'Voice Cues'**
  String get settingsVoiceCues;

  /// Voice cues setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Play audio prompts during exercises'**
  String get settingsVoiceCuesSubtitle;

  /// Daily reminder setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Receive a daily reminder to complete your exercises'**
  String get settingsDailyReminderSubtitle;

  /// Account section header in settings
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// Notification permission denied dialog title
  ///
  /// In en, this message translates to:
  /// **'Notification Permission Denied'**
  String get settingsNotificationPermissionDeniedTitle;

  /// Notification permission denied dialog message
  ///
  /// In en, this message translates to:
  /// **'Notification permission was denied. Please enable notifications in your device settings to receive reminders.'**
  String get settingsNotificationPermissionDeniedMessage;

  /// Empty state title on SOS page
  ///
  /// In en, this message translates to:
  /// **'No emergency contacts'**
  String get sosNoEmergencyContacts;

  /// Empty state subtitle on SOS page
  ///
  /// In en, this message translates to:
  /// **'Add emergency contacts in your profile to use this feature.'**
  String get sosAddContactsMessage;

  /// Error when calling is not supported
  ///
  /// In en, this message translates to:
  /// **'Calling is not supported on this device.'**
  String get sosCallingNotSupported;

  /// Full safety reminder on SOS page
  ///
  /// In en, this message translates to:
  /// **'If you have fallen and cannot get up, remain calm and stay on the floor until help arrives. Call emergency services or a contact below.'**
  String get sosSafetyReminderFull;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// OK button label
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Loading label for dashboard
  ///
  /// In en, this message translates to:
  /// **'Loading dashboard…'**
  String get loadingDashboard;

  /// Question in onboarding step 4
  ///
  /// In en, this message translates to:
  /// **'Do you use a walking aid?'**
  String get onboardingStep4Question;

  /// Yes option
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get onboardingYes;

  /// No option
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get onboardingNo;

  /// Age field label in step 1
  ///
  /// In en, this message translates to:
  /// **'Your Age'**
  String get onboardingStep1AgeLabel;

  /// Age field hint in step 1
  ///
  /// In en, this message translates to:
  /// **'Enter your age'**
  String get onboardingStep1AgeHint;

  /// Age field suffix in step 1
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get onboardingStep1AgeSuffix;

  /// Age required validation in step 1
  ///
  /// In en, this message translates to:
  /// **'Please enter your age'**
  String get onboardingStep1AgeRequired;

  /// Age range validation in step 1
  ///
  /// In en, this message translates to:
  /// **'Age must be between 18 and 120'**
  String get onboardingStep1AgeRange;

  /// Gender field label in step 1
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get onboardingStep1GenderLabel;

  /// Male gender option
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get onboardingStep1GenderMale;

  /// Female gender option
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get onboardingStep1GenderFemale;

  /// Other gender option
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get onboardingStep1GenderOther;

  /// Prefer not to say gender option
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get onboardingStep1GenderPreferNotToSay;

  /// Question in step 2
  ///
  /// In en, this message translates to:
  /// **'How many times have you fallen in the last 12 months?'**
  String get onboardingStep2Question;

  /// Falls field hint in step 2
  ///
  /// In en, this message translates to:
  /// **'Enter number of falls'**
  String get onboardingStep2Hint;

  /// Falls field suffix in step 2
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get onboardingStep2Suffix;

  /// Falls required validation in step 2
  ///
  /// In en, this message translates to:
  /// **'Please enter the number of falls (enter 0 if none)'**
  String get onboardingStep2Required;

  /// Falls invalid validation in step 2
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number (0 or more)'**
  String get onboardingStep2Invalid;

  /// Question in step 3
  ///
  /// In en, this message translates to:
  /// **'Do you have any of the following health conditions?'**
  String get onboardingStep3Question;

  /// Select all hint in step 3
  ///
  /// In en, this message translates to:
  /// **'Select all that apply'**
  String get onboardingStep3SelectAll;

  /// Musculoskeletal condition
  ///
  /// In en, this message translates to:
  /// **'Muskuloskeletal'**
  String get onboardingStep3Musculoskeletal;

  /// Musculoskeletal subtitle
  ///
  /// In en, this message translates to:
  /// **'Joint/bone problems'**
  String get onboardingStep3MusculoskeletalSub;

  /// Circulatory condition
  ///
  /// In en, this message translates to:
  /// **'Sirkulasi'**
  String get onboardingStep3Circulatory;

  /// Circulatory subtitle
  ///
  /// In en, this message translates to:
  /// **'Heart/blood pressure'**
  String get onboardingStep3CirculatorySub;

  /// Respiratory condition
  ///
  /// In en, this message translates to:
  /// **'Pernapasan'**
  String get onboardingStep3Respiratory;

  /// Respiratory subtitle
  ///
  /// In en, this message translates to:
  /// **'Breathing problems'**
  String get onboardingStep3RespiratorySub;

  /// Neurological condition
  ///
  /// In en, this message translates to:
  /// **'Neurologis'**
  String get onboardingStep3Neurological;

  /// Neurological subtitle
  ///
  /// In en, this message translates to:
  /// **'Nerve/brain conditions'**
  String get onboardingStep3NeurologicalSub;

  /// Other condition
  ///
  /// In en, this message translates to:
  /// **'Lainnya'**
  String get onboardingStep3Other;

  /// Question in step 5
  ///
  /// In en, this message translates to:
  /// **'How concerned are you about falling?'**
  String get onboardingStep5Question;

  /// Fear level 1 description
  ///
  /// In en, this message translates to:
  /// **'Not at all concerned'**
  String get onboardingStep5Level1;

  /// Fear level 2 description
  ///
  /// In en, this message translates to:
  /// **'Slightly concerned'**
  String get onboardingStep5Level2;

  /// Fear level 3 description
  ///
  /// In en, this message translates to:
  /// **'Moderately concerned'**
  String get onboardingStep5Level3;

  /// Fear level 4 description
  ///
  /// In en, this message translates to:
  /// **'Very concerned'**
  String get onboardingStep5Level4;

  /// Fear level 5 description
  ///
  /// In en, this message translates to:
  /// **'Extremely concerned'**
  String get onboardingStep5Level5;

  /// Time label in step 6
  ///
  /// In en, this message translates to:
  /// **'Preferred exercise time'**
  String get onboardingStep6TimeLabel;

  /// Time hint in step 6
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get onboardingStep6TimeHint;

  /// Duration label in step 6
  ///
  /// In en, this message translates to:
  /// **'Session duration'**
  String get onboardingStep6DurationLabel;

  /// Duration hint in step 6
  ///
  /// In en, this message translates to:
  /// **'Enter duration'**
  String get onboardingStep6DurationHint;

  /// Duration suffix in step 6
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get onboardingStep6DurationSuffix;

  /// Duration required validation
  ///
  /// In en, this message translates to:
  /// **'Please enter session duration'**
  String get onboardingStep6DurationRequired;

  /// Duration range validation
  ///
  /// In en, this message translates to:
  /// **'Duration must be between 10 and 120 minutes'**
  String get onboardingStep6DurationRange;

  /// Frequency label in step 6
  ///
  /// In en, this message translates to:
  /// **'Weekly frequency'**
  String get onboardingStep6FrequencyLabel;

  /// Frequency hint in step 6
  ///
  /// In en, this message translates to:
  /// **'Enter frequency'**
  String get onboardingStep6FrequencyHint;

  /// Frequency suffix in step 6
  ///
  /// In en, this message translates to:
  /// **'days per week'**
  String get onboardingStep6FrequencySuffix;

  /// Frequency required validation
  ///
  /// In en, this message translates to:
  /// **'Please enter weekly frequency'**
  String get onboardingStep6FrequencyRequired;

  /// Frequency range validation
  ///
  /// In en, this message translates to:
  /// **'Frequency must be between 1 and 7 days per week'**
  String get onboardingStep6FrequencyRange;

  /// Outcome goal label in step 7
  ///
  /// In en, this message translates to:
  /// **'Outcome Goal'**
  String get onboardingStep7OutcomeLabel;

  /// Outcome goal hint in step 7
  ///
  /// In en, this message translates to:
  /// **'What do you want to achieve? (e.g., Walk to the market independently)'**
  String get onboardingStep7OutcomeHint;

  /// Outcome goal required validation
  ///
  /// In en, this message translates to:
  /// **'Please describe what you want to achieve'**
  String get onboardingStep7OutcomeRequired;

  /// Behavioural goal label in step 7
  ///
  /// In en, this message translates to:
  /// **'Behavioural Goal'**
  String get onboardingStep7BehaviouralLabel;

  /// Behavioural goal hint in step 7
  ///
  /// In en, this message translates to:
  /// **'What exercise will you do and when? (e.g., Exercise every morning)'**
  String get onboardingStep7BehaviouralHint;

  /// Behavioural goal required validation
  ///
  /// In en, this message translates to:
  /// **'Please describe your exercise plan'**
  String get onboardingStep7BehaviouralRequired;
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
