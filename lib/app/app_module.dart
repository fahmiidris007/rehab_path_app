import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// External dependency registrations for the DI container.
///
/// Hive boxes are registered as lazy singletons with named instances so they
/// can be injected by name throughout the app.
@module
abstract class AppModule {
  /// SharedPreferences instance — resolved asynchronously before the app starts.
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  /// Logger instance for structured logging throughout the app.
  @lazySingleton
  Logger get logger => Logger();

  /// FlutterLocalNotificationsPlugin instance for scheduling notifications.
  @lazySingleton
  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      FlutterLocalNotificationsPlugin();

  /// Platform biometric authentication wrapper.
  @lazySingleton
  LocalAuthentication get localAuth => LocalAuthentication();

  /// Encrypted on-device key/value storage (Android Keystore / iOS Keychain).
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  // ---------------------------------------------------------------------------
  // Hive boxes
  // ---------------------------------------------------------------------------

  /// User profiles box.
  @lazySingleton
  @Named('userBox')
  Box<dynamic> get userBox => Hive.box('userBox');

  /// Completed exercise sessions box.
  @lazySingleton
  @Named('sessionBox')
  Box<dynamic> get sessionBox => Hive.box('sessionBox');

  /// Fall diary entries box.
  @lazySingleton
  @Named('fallEventBox')
  Box<dynamic> get fallEventBox => Hive.box('fallEventBox');

  /// Earned badges box.
  @lazySingleton
  @Named('badgeBox')
  Box<dynamic> get badgeBox => Hive.box('badgeBox');

  /// Onboarding profiles box.
  @lazySingleton
  @Named('onboardingBox')
  Box<dynamic> get onboardingBox => Hive.box('onboardingBox');

  /// App settings box.
  @lazySingleton
  @Named('settingsBox')
  Box<dynamic> get settingsBox => Hive.box('settingsBox');

  /// Notification milestone flags box.
  @lazySingleton
  @Named('notificationBox')
  Box<dynamic> get notificationBox => Hive.box('notificationBox');
}
