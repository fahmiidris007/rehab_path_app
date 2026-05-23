// Integration test (task 16.4): saving an exercise session and then calling
// [HomeCubit.refreshAfterSession] updates the dashboard ring + streak only
// when the session's `exerciseId` is part of today's schedule. Sessions for
// exercises **not** in today's schedule MUST NOT change `completedToday`.
//
// **Validates: Requirements 6.1, 6.2, 6.3, 6.4, 10.5, 11.3.**
//
// Approach
// --------
// This is a cubit-level integration: we exercise the real [HomeCubit]
// against a real [HiveDataSource] backed by `hive_test`, with the full
// DI graph wired through `configureDependencies()`. No widget tree is
// built — we drive `HomeCubit.loadDashboard` and `refreshAfterSession`
// directly and assert against the [HomeData] snapshots that the cubit
// emits.
//
// Why this complements the unit-level Property 9 in
// `test/features/home/presentation/cubit/home_cubit_test.dart`:
//
//   * The dashboard aggregation runs against the **real** catalogue from
//     `assets/data/dummy_exercises.json` and the **real** schedule
//     generator (`ExerciseRepositoryImpl.getScheduleForDate`), exercising
//     `Modul_Exercise` end-to-end alongside `HomeCubit`.
//   * Sessions are persisted to a real Hive box so the read-side filter
//     in `refreshAfterSession` runs over genuine deserialized records.
//   * The `progressRingPercent` formula (R6.4 / R10.5) is verified after a
//     real session save, not via a hand-built [HomeData] fixture.
//   * Confirms that the post-save data-contract (R11.3) holds: after a
//     scheduled session, the cubit transitions to `HomeLoaded` with the
//     metrics updated within a single async cycle.
//
// Test harness
// ------------
// Each test resets the DI container and Hive between runs, so iterations
// are hermetic. We register Hive adapters and open the named boxes first
// (mirroring `lib/main.dart`), then call `configureDependencies()` so the
// `@Named('userBox')` etc. registrations resolve to the live boxes.

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rehab_path_app/core/constants/app_constants.dart';
import 'package:rehab_path_app/core/utils/date_utils.dart';
import 'package:rehab_path_app/di/injection.dart';
import 'package:rehab_path_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:rehab_path_app/features/home/presentation/cubit/home_state.dart';
import 'package:rehab_path_app/shared/data/datasources/dummy_data_source.dart';
import 'package:rehab_path_app/shared/data/datasources/hive_data_source.dart';
import 'package:rehab_path_app/shared/data/models/badge_hive_model.dart';
import 'package:rehab_path_app/shared/data/models/emergency_contact_hive_model.dart';
import 'package:rehab_path_app/shared/data/models/exercise_session_hive_model.dart';
import 'package:rehab_path_app/shared/data/models/fall_event_hive_model.dart';
import 'package:rehab_path_app/shared/data/models/onboarding_profile_hive_model.dart';
import 'package:rehab_path_app/shared/data/models/scheduled_exercise_set_hive_model.dart';
import 'package:rehab_path_app/shared/data/models/user_hive_model.dart';
import 'package:rehab_path_app/shared/domain/entities/emergency_contact_entity.dart';
import 'package:rehab_path_app/shared/domain/entities/exercise_entity.dart';
import 'package:rehab_path_app/shared/domain/entities/onboarding_profile_entity.dart';
import 'package:rehab_path_app/shared/domain/entities/user_entity.dart';
import 'package:rehab_path_app/shared/domain/enums/app_enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// All Hive box names used by [HiveDataSource] except the optional schedule
/// cache box (which uses a typed `Box<ScheduledExerciseSetHiveModel>`).
const _genericBoxNames = <String>[
  AppConstants.hiveBoxUser,
  AppConstants.hiveBoxSession,
  AppConstants.hiveBoxFallEvent,
  AppConstants.hiveBoxBadge,
  AppConstants.hiveBoxOnboarding,
  AppConstants.hiveBoxSettings,
  AppConstants.hiveBoxNotification,
];

/// Registers the Hive adapters used by the app, mirroring `lib/main.dart`.
///
/// `hive_test` resets adapters between tests, so this is safe to call in
/// every `setUp`. The schedule adapter (typeId 11) is wrapped in a guard so
/// the rest of the suite still functions if Hive's adapter registry is in
/// an unexpected state.
void _registerAdapters() {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserHiveModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(EmergencyContactHiveModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(OnboardingProfileHiveModelAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(ExerciseSessionHiveModelAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(FallEventHiveModelAdapter());
  }
  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(BadgeHiveModelAdapter());
  }
  if (!Hive.isAdapterRegistered(11)) {
    Hive.registerAdapter(ScheduledExerciseSetHiveModelAdapter());
  }
}

Future<void> _openBoxes() async {
  for (final name in _genericBoxNames) {
    await Hive.openBox<dynamic>(name);
  }
  await Hive.openBox<ScheduledExerciseSetHiveModel>(
    AppConstants.hiveBoxSchedule,
  );
}

Future<void> _closeAndDeleteBoxes() async {
  for (final name in [..._genericBoxNames, AppConstants.hiveBoxSchedule]) {
    if (Hive.isBoxOpen(name)) {
      await Hive.box<dynamic>(name).close();
    }
  }
}

/// A canonical seeded user. The `programLevel` matches at least one entry in
/// `assets/data/dummy_exercises.json` so the schedule generator returns a
/// non-empty list.
UserEntity _seedUser() => const UserEntity(
      id: 'user_session_refresh_test',
      name: 'Session Refresh Test',
      phoneNumber: '+6281100000099',
      age: 70,
      gender: 'female',
      programLevel: ProgramLevel.beginner,
      healthConditions: <String>[],
      emergencyContacts: <EmergencyContactEntity>[],
      onboardingProfile: OnboardingProfileEntity(
        age: 70,
        gender: 'female',
        fallsInLastYear: 0,
        healthConditions: <String>[],
        usesWalkingAid: false,
        fearOfFallingScore: 1,
        preferredExerciseTime: '08:00',
        sessionDurationMinutes: 30,
        weeklyFrequencyTarget: 4,
        outcomeGoal: 'goal',
        behaviouralGoal: 'b_goal',
        programLevel: ProgramLevel.beginner,
        lastCompletedStep: 7,
      ),
    );

/// Builds an [ExerciseSessionHiveModel] with a unique id for [exerciseId]
/// completed at the given local-day [completedAt]. A microsecond-grained id
/// avoids collisions if the test saves multiple sessions back-to-back.
ExerciseSessionHiveModel _buildSession({
  required String userId,
  required String exerciseId,
  required DateTime completedAt,
}) {
  final id = 'session_${userId}_${completedAt.microsecondsSinceEpoch}_'
      '$exerciseId';
  return ExerciseSessionHiveModel(
    id: id,
    exerciseId: exerciseId,
    userId: userId,
    completedAt: completedAt,
    bodyCondition: BodyCondition.standing.name,
    supportUsed: SupportUsed.noSupport.name,
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await setUpTestHive();
    _registerAdapters();
    await _openBoxes();

    // Configure the DI graph against the live boxes / mocked SharedPreferences.
    if (getIt.isRegistered<HomeCubit>()) {
      await getIt.reset();
    }
    await configureDependencies();

    // Seed the canonical test user so HomeCubit.loadDashboard finds a known
    // profile in Hive.
    await getIt<HiveDataSource>().saveUser(
      UserHiveModel.fromEntity(_seedUser()),
    );
  });

  tearDown(() async {
    if (getIt.isRegistered<HomeCubit>()) {
      await getIt.reset();
    }
    await _closeAndDeleteBoxes();
    await tearDownTestHive();
  });

  testWidgets(
    'completing a SCHEDULED exercise updates completedToday and the progress '
    'ring after refreshAfterSession (R6.1, R6.2, R6.4, R10.5, R11.3)',
    (tester) async {
      final user = _seedUser();
      final cubit = getIt<HomeCubit>();
      await cubit.loadDashboard(user);

      expect(cubit.state, isA<HomeLoaded>());
      var data = (cubit.state as HomeLoaded).data;

      // Sanity: the seeded beginner catalogue should yield a non-empty
      // schedule. If this fails, the dummy_exercises.json catalogue or the
      // ScheduleSeedGenerator changed in a way that breaks this test's
      // assumption.
      expect(
        data.todaySchedule,
        isNotEmpty,
        reason: 'Beginner schedule must be non-empty for this test',
      );
      final initialCompletedToday = data.completedToday;
      expect(
        initialCompletedToday,
        equals(0),
        reason: 'Test starts with no sessions; completedToday must be 0',
      );
      expect(
        data.progressRingPercent,
        equals(0),
        reason: 'Initial ring must read 0% with no completed sessions',
      );

      // Pick the first exercise from today's schedule. Its id is guaranteed
      // to be in the in-schedule set used by the aggregation filter.
      final scheduledExercise = data.todaySchedule.first;

      // Persist a session at midday today via the live HiveDataSource so the
      // read path in refreshAfterSession exercises a genuine deserialised
      // record.
      final completedAt = AppDateUtils.todayLocal()
          .add(const Duration(hours: 12));
      await getIt<HiveDataSource>().saveSession(
        _buildSession(
          userId: user.id,
          exerciseId: scheduledExercise.id,
          completedAt: completedAt,
        ),
      );

      // R11.3 — refreshAfterSession must transition the cubit to a
      // non-loading terminal state with the metrics updated.
      await cubit.refreshAfterSession();

      expect(cubit.state, isA<HomeLoaded>());
      data = (cubit.state as HomeLoaded).data;

      // R6.1 / R6.2 — completedToday goes 0 → 1 because the session is
      // in today's schedule.
      expect(
        data.completedToday,
        equals(initialCompletedToday + 1),
        reason: 'Scheduled session must increment completedToday by exactly 1',
      );
      // totalSessions reflects every persisted session, including in- and
      // out-of-schedule.
      expect(data.totalSessions, equals(1));

      // R6.4 / R10.5 — ring percentage matches
      // round(completedToday / scheduleLen * 100).
      final expectedRing =
          ((data.completedToday / data.selectedDateSchedule.length) * 100)
              .round();
      expect(
        data.progressRingPercent,
        equals(expectedRing),
        reason: 'Ring formula must hold after a scheduled session save',
      );

      // While viewing today, view-mode mirrors today.
      expect(data.selectedDateCompleted, equals(data.completedToday));
      expect(data.selectedDateSchedule, equals(data.todaySchedule));

      await cubit.close();
    },
  );

  testWidgets(
    'completing a NON-SCHEDULED exercise leaves completedToday unchanged '
    'after refreshAfterSession (R6.2, R6.3)',
    (tester) async {
      final user = _seedUser();
      final cubit = getIt<HomeCubit>();
      await cubit.loadDashboard(user);

      expect(cubit.state, isA<HomeLoaded>());
      var data = (cubit.state as HomeLoaded).data;

      // Capture the persistent-metric snapshot before saving an
      // out-of-schedule session.
      final initialCompletedToday = data.completedToday;
      final initialRing = data.progressRingPercent;
      final initialTodaySchedule = List<ExerciseEntity>.of(data.todaySchedule);

      expect(initialCompletedToday, equals(0));
      expect(initialRing, equals(0));

      // Find an exercise in the catalogue whose id is NOT in today's
      // schedule. The beginner catalogue has multiple entries, so this is
      // virtually guaranteed to find one.
      final allExercises = await getIt<DummyDataSource>().loadExercises();
      final scheduleIds =
          initialTodaySchedule.map((e) => e.id).toSet();
      final nonScheduledExercise = allExercises.firstWhere(
        (e) => !scheduleIds.contains(e.id),
        orElse: () => throw StateError(
          'No catalogue exercise found outside today\'s schedule; '
          'the assets/data/dummy_exercises.json catalogue may have shrunk.',
        ),
      );

      // Persist the out-of-schedule session at midday today.
      final completedAt = AppDateUtils.todayLocal()
          .add(const Duration(hours: 12));
      await getIt<HiveDataSource>().saveSession(
        _buildSession(
          userId: user.id,
          exerciseId: nonScheduledExercise.id,
          completedAt: completedAt,
        ),
      );

      await cubit.refreshAfterSession();

      expect(cubit.state, isA<HomeLoaded>());
      data = (cubit.state as HomeLoaded).data;

      // R6.2 — out-of-schedule session must NOT bump completedToday.
      expect(
        data.completedToday,
        equals(initialCompletedToday),
        reason: 'Out-of-schedule session must not change completedToday',
      );
      // R6.4 — and therefore the ring stays at its previous value (0%).
      expect(
        data.progressRingPercent,
        equals(initialRing),
        reason: 'Out-of-schedule session must not change the progress ring',
      );

      // The session is still saved in Hive (R6.5) and reflected in
      // totalSessions, which is intentionally NOT filtered by schedule.
      expect(
        data.totalSessions,
        equals(1),
        reason: 'totalSessions must still include out-of-schedule sessions',
      );

      // Today's schedule itself is invariant under session saves — only the
      // aggregation derived from it changes.
      expect(data.todaySchedule, equals(initialTodaySchedule));

      await cubit.close();
    },
  );

  testWidgets(
    'mixing one scheduled + one non-scheduled session yields completedToday '
    '== 1 and totalSessions == 2 (R6.2, R6.5)',
    (tester) async {
      final user = _seedUser();
      final cubit = getIt<HomeCubit>();
      await cubit.loadDashboard(user);

      expect(cubit.state, isA<HomeLoaded>());
      var data = (cubit.state as HomeLoaded).data;

      final scheduledExercise = data.todaySchedule.first;
      final allExercises = await getIt<DummyDataSource>().loadExercises();
      final scheduleIds = data.todaySchedule.map((e) => e.id).toSet();
      final nonScheduledExercise = allExercises.firstWhere(
        (e) => !scheduleIds.contains(e.id),
        orElse: () => throw StateError(
          'No catalogue exercise found outside today\'s schedule',
        ),
      );

      final today = AppDateUtils.todayLocal();
      final hive = getIt<HiveDataSource>();

      // Save scheduled session first.
      await hive.saveSession(_buildSession(
        userId: user.id,
        exerciseId: scheduledExercise.id,
        completedAt: today.add(const Duration(hours: 9)),
      ));
      await cubit.refreshAfterSession();
      data = (cubit.state as HomeLoaded).data;
      expect(data.completedToday, equals(1));
      expect(data.totalSessions, equals(1));

      // Then save non-scheduled session.
      await hive.saveSession(_buildSession(
        userId: user.id,
        exerciseId: nonScheduledExercise.id,
        completedAt: today.add(const Duration(hours: 10)),
      ));
      await cubit.refreshAfterSession();
      data = (cubit.state as HomeLoaded).data;

      // R6.2 — only the scheduled session contributes to completedToday.
      expect(
        data.completedToday,
        equals(1),
        reason: 'Only the scheduled session may bump completedToday',
      );
      // R6.5 — both sessions are persisted; totalSessions reflects this.
      expect(
        data.totalSessions,
        equals(2),
        reason: 'Both sessions must be persisted in Hive',
      );

      await cubit.close();
    },
  );
}
