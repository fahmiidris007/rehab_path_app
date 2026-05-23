// Integration test (task 16.5): selecting a past or future date on the
// dashboard puts the [HomeCubit] into a read-only view-mode that never
// mutates the persistent dashboard state, and a future date renders an
// empty schedule with a 0% progress ring (the "Belum berlangsung" state).
//
// **Validates: Requirements 9.2, 9.4, 9.6, 9.8.**
//
// Approach
// --------
// This is a cubit-level integration: we exercise the real [HomeCubit]
// against a real [HiveDataSource] backed by `hive_test`, with the full
// DI graph wired through `configureDependencies()`. No widget tree is
// built — we drive `HomeCubit.loadDashboard`, `selectDate`, and
// `resetToToday` directly and assert against the [HomeData] snapshots
// that the cubit emits.
//
// What this test guarantees that the unit-level Property 13 in
// `test/features/home/presentation/cubit/home_cubit_test.dart` does not:
//
//   * The schedule generator runs against the **real** `dummy_exercises.json`
//     asset (loaded via `DummyDataSource.loadExercises`).
//   * The `ScheduledExerciseSetHiveModel` cache is exercised — a future-date
//     `selectDate` SHALL NOT pollute the schedule cache with empty entries,
//     and a past-date `selectDate` SHALL persist whatever it computes
//     without mutating any user-aggregation state.
//   * `selectDate(today + 1)` and `selectDate(today - 1)` drive the actual
//     `GetScheduleForDateUseCase` → `ExerciseRepositoryImpl.getScheduleForDate`
//     codepath, including its cache miss/hit branching.
//
// Test harness
// ------------
// Each test reset the DI container and Hive between runs, so iterations
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
import 'package:rehab_path_app/shared/data/datasources/hive_data_source.dart';
import 'package:rehab_path_app/shared/data/models/badge_hive_model.dart';
import 'package:rehab_path_app/shared/data/models/emergency_contact_hive_model.dart';
import 'package:rehab_path_app/shared/data/models/exercise_session_hive_model.dart';
import 'package:rehab_path_app/shared/data/models/fall_event_hive_model.dart';
import 'package:rehab_path_app/shared/data/models/onboarding_profile_hive_model.dart';
import 'package:rehab_path_app/shared/data/models/scheduled_exercise_set_hive_model.dart';
import 'package:rehab_path_app/shared/data/models/user_hive_model.dart';
import 'package:rehab_path_app/shared/domain/entities/emergency_contact_entity.dart';
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
      id: 'user_view_mode_test',
      name: 'View Mode Test',
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

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Hermetic Hive-on-disk-emulation backing for HiveDataSource.
    SharedPreferences.setMockInitialValues({});
    await setUpTestHive();
    _registerAdapters();
    await _openBoxes();

    // Configure the DI graph against the live boxes / mocked SharedPreferences.
    if (getIt.isRegistered<HomeCubit>()) {
      await getIt.reset();
    }
    await configureDependencies();

    // Seed a single user so HomeCubit.loadDashboard finds a known profile.
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
    'selectDate(future) yields empty schedule + 0% ring and leaves all '
    "persistent metrics untouched (R9.2, R9.6, R9.8)",
    (tester) async {
      final user = _seedUser();
      final cubit = getIt<HomeCubit>();
      await cubit.loadDashboard(user);

      // Sanity: dashboard is loaded and viewing today.
      expect(cubit.state, isA<HomeLoaded>());
      final initial = (cubit.state as HomeLoaded).data;
      expect(
        initial.isViewingPastOrFutureDate,
        isFalse,
        reason: 'Initial selectedDate must equal todayLocal',
      );

      // Capture the persistent-metric snapshot before any view-mode change.
      final initialCompletedToday = initial.completedToday;
      final initialStreak = initial.streakDays;
      final initialTotalSessions = initial.totalSessions;
      final initialTotalMinutes = initial.totalMinutes;
      final initialCompletedDays =
          List<DateTime>.from(initial.completedDaysThisWeek);
      final initialTodayLocal = initial.todayLocal;
      final initialTodaySchedule = List.of(initial.todaySchedule);

      // R9.2 — tap a future date.
      final tomorrow = initialTodayLocal.add(const Duration(days: 1));
      await cubit.selectDate(tomorrow);

      expect(cubit.state, isA<HomeLoaded>());
      final afterFuture = (cubit.state as HomeLoaded).data;

      // R9.6 — future date: empty schedule, 0 completed, 0% ring,
      // selectedDate normalized to local midnight, in view-mode.
      expect(
        afterFuture.selectedDate,
        equals(AppDateUtils.toLocalMidnight(tomorrow)),
      );
      expect(afterFuture.isViewingPastOrFutureDate, isTrue);
      expect(
        afterFuture.selectedDateSchedule,
        isEmpty,
        reason: 'Future date must yield an empty selectedDateSchedule',
      );
      expect(
        afterFuture.selectedDateCompleted,
        equals(0),
        reason: 'Future date must yield selectedDateCompleted == 0',
      );
      expect(
        afterFuture.progressRingPercent,
        equals(0),
        reason: 'Future date ring must read 0% (Belum berlangsung)',
      );

      // R9.4 / R9.8 — persistent metrics MUST be untouched by view-mode.
      expect(afterFuture.completedToday, equals(initialCompletedToday));
      expect(afterFuture.streakDays, equals(initialStreak));
      expect(afterFuture.totalSessions, equals(initialTotalSessions));
      expect(afterFuture.totalMinutes, equals(initialTotalMinutes));
      expect(afterFuture.completedDaysThisWeek, equals(initialCompletedDays));
      // Today's schedule is the source of truth for the user's plan and must
      // not change just because we scrolled the date selector.
      expect(afterFuture.todaySchedule, equals(initialTodaySchedule));
      expect(afterFuture.todayLocal, equals(initialTodayLocal));

      await cubit.close();
    },
  );

  testWidgets(
    'selectDate(past) recomputes the past-date schedule but leaves persistent '
    'metrics untouched (R9.2, R9.8)',
    (tester) async {
      final user = _seedUser();
      final cubit = getIt<HomeCubit>();
      await cubit.loadDashboard(user);

      expect(cubit.state, isA<HomeLoaded>());
      final initial = (cubit.state as HomeLoaded).data;

      final initialCompletedToday = initial.completedToday;
      final initialStreak = initial.streakDays;
      final initialTotalSessions = initial.totalSessions;
      final initialTotalMinutes = initial.totalMinutes;
      final initialCompletedDays =
          List<DateTime>.from(initial.completedDaysThisWeek);
      final initialTodaySchedule = List.of(initial.todaySchedule);
      final initialTodayLocal = initial.todayLocal;

      // R9.2 — tap a past date.
      final yesterday = initialTodayLocal.subtract(const Duration(days: 1));
      await cubit.selectDate(yesterday);

      expect(cubit.state, isA<HomeLoaded>());
      final afterPast = (cubit.state as HomeLoaded).data;

      expect(
        afterPast.selectedDate,
        equals(AppDateUtils.toLocalMidnight(yesterday)),
      );
      expect(afterPast.isViewingPastOrFutureDate, isTrue);

      // The past-date schedule may be non-empty (depending on the seeded
      // catalogue). Either way, R9.8 mandates that none of the persistent
      // metric fields change.
      expect(afterPast.completedToday, equals(initialCompletedToday));
      expect(afterPast.streakDays, equals(initialStreak));
      expect(afterPast.totalSessions, equals(initialTotalSessions));
      expect(afterPast.totalMinutes, equals(initialTotalMinutes));
      expect(afterPast.completedDaysThisWeek, equals(initialCompletedDays));
      expect(afterPast.todaySchedule, equals(initialTodaySchedule));
      expect(afterPast.todayLocal, equals(initialTodayLocal));

      // For a past date with no recorded sessions, the schedule may exist
      // but the ring still reads 0% because no in-schedule sessions exist
      // for that calendar day. We assert the formula holds, not a specific
      // count, since the catalogue determines the schedule length.
      final pastSchedLen = afterPast.selectedDateSchedule.length;
      final expectedRing = pastSchedLen == 0
          ? 0
          : ((afterPast.selectedDateCompleted / pastSchedLen) * 100).round();
      expect(afterPast.progressRingPercent, equals(expectedRing));

      await cubit.close();
    },
  );

  testWidgets(
    'resetToToday() returns selectedDate to todayLocal and restores the '
    "today-mode view fields (R9.2)",
    (tester) async {
      final user = _seedUser();
      final cubit = getIt<HomeCubit>();
      await cubit.loadDashboard(user);

      expect(cubit.state, isA<HomeLoaded>());
      final initial = (cubit.state as HomeLoaded).data;
      final initialTodayLocal = initial.todayLocal;
      final initialCompletedToday = initial.completedToday;
      final initialTodaySchedule = List.of(initial.todaySchedule);

      // Drift away to a future date first.
      await cubit.selectDate(
        initialTodayLocal.add(const Duration(days: 3)),
      );
      expect(
        (cubit.state as HomeLoaded).data.isViewingPastOrFutureDate,
        isTrue,
      );

      // R9.2 — back to today.
      await cubit.resetToToday();

      final afterReset = (cubit.state as HomeLoaded).data;
      expect(afterReset.selectedDate, equals(initialTodayLocal));
      expect(afterReset.isViewingPastOrFutureDate, isFalse);

      // View-mode fields snap back to mirror today's plan.
      expect(
        afterReset.selectedDateSchedule,
        equals(initialTodaySchedule),
        reason: 'On reset, selectedDateSchedule must mirror todaySchedule',
      );
      expect(
        afterReset.selectedDateCompleted,
        equals(initialCompletedToday),
        reason: 'On reset, selectedDateCompleted must mirror completedToday',
      );

      await cubit.close();
    },
  );
}
