import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'app/app.dart';
import 'core/constants/app_constants.dart';
import 'di/injection.dart';
import 'shared/data/models/badge_hive_model.dart';
import 'shared/data/models/emergency_contact_hive_model.dart';
import 'shared/data/models/exercise_session_hive_model.dart';
import 'shared/data/models/fall_event_hive_model.dart';
import 'shared/data/models/onboarding_profile_hive_model.dart';
import 'shared/data/models/scheduled_exercise_set_hive_model.dart';
import 'shared/data/models/user_hive_model.dart';
import 'shared/data/seeding/data_seeder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive type adapters before opening boxes
  Hive.registerAdapter(UserHiveModelAdapter());
  Hive.registerAdapter(EmergencyContactHiveModelAdapter());
  Hive.registerAdapter(OnboardingProfileHiveModelAdapter());
  Hive.registerAdapter(ExerciseSessionHiveModelAdapter());
  Hive.registerAdapter(FallEventHiveModelAdapter());
  Hive.registerAdapter(BadgeHiveModelAdapter());

  // Schedule cache adapter (typeId: 11) is optional — if registration or box
  // opening fails, the schedule will simply be recomputed every call via
  // `ScheduleSeedGenerator`, since the cache is not the source of truth.
  // Repositories MUST gate reads/writes on `Hive.isAdapterRegistered(11)`.
  final logger = Logger();
  try {
    Hive.registerAdapter(ScheduledExerciseSetHiveModelAdapter());
    await Hive.openBox<ScheduledExerciseSetHiveModel>(
      AppConstants.hiveBoxSchedule,
    );
  } catch (e, stackTrace) {
    logger.w(
      'Failed to register ScheduledExerciseSetHiveModelAdapter or open '
      'scheduleBox; falling back to recomputed schedule per call.',
      error: e,
      stackTrace: stackTrace,
    );
  }

  // Open all Hive boxes
  await Future.wait([
    Hive.openBox<dynamic>(AppConstants.hiveBoxUser),
    Hive.openBox<dynamic>(AppConstants.hiveBoxSession),
    Hive.openBox<dynamic>(AppConstants.hiveBoxFallEvent),
    Hive.openBox<dynamic>(AppConstants.hiveBoxBadge),
    Hive.openBox<dynamic>(AppConstants.hiveBoxOnboarding),
    Hive.openBox<dynamic>(AppConstants.hiveBoxSettings),
    Hive.openBox<dynamic>(AppConstants.hiveBoxNotification),
  ]);

  await configureDependencies();

  // Initialize flutter_local_notifications
  const initializationSettingsAndroid = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );
  const initializationSettingsIOS = DarwinInitializationSettings();
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await getIt<FlutterLocalNotificationsPlugin>().initialize(
    initializationSettings,
  );

  // Initialize timezone data
  tz.initializeTimeZones();

  await getIt<DataSeeder>().seedIfNeeded();

  runApp(TemanLansiaApp());
}
