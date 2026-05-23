// Property-based tests for [HomeCubit] dashboard aggregation contract.
//
// This file is the home for three properties from
// `.kiro/specs/app-flow-adjustments/tasks.md`:
//
//   * Property 9 (task 10.4): Dashboard aggregation only counts in-schedule
//     sessions. **Validates: Requirements 6.2, 6.3**
//
//   * Property 10 (task 10.5): Progress ring percent matches the formula.
//     **Validates: Requirements 6.4, 9.7**
//
//   * Property 13 (task 10.6): View-mode is read-only and leaves the
//     persistent state untouched.
//     **Validates: Requirements 9.4, 9.6, 9.8**
//
// Test strategy
// -------------
// `HomeCubit` depends on six collaborators:
//   * [GetRandomMessageUseCase]      — pure read, stubbed to a fixed message.
//   * [GetStreakUseCase]             — stubbed to return a fixed streak.
//   * [GetTodayScheduleUseCase]      — stubbed to return a fixed 4-exercise
//                                      schedule.
//   * [GetExercisesByLevelUseCase]   — stubbed to return an empty recommended
//                                      list (irrelevant for the properties).
//   * [GetScheduleForDateUseCase]    — stubbed per-test for view-mode.
//   * [HiveDataSource]               — stubbed so `getAllSessions()` returns
//                                      a generator-driven list.
//
// All collaborators are faked with `mocktail`. Glados drives variation across
// session-id mixes, schedule lengths, and day offsets.
//
// Property 10 is a formula property — it constructs `HomeData` directly
// rather than driving the cubit, since the formula is exposed as the pure
// getter `progressRingPercent`.
//
// Import note: glados re-exports `package:test_core/scaffolding.dart`, which
// collides with `flutter_test`'s `setUpAll`/`group`/`test`/`expect`. We keep
// the `flutter_test` versions and hide the duplicates from glados. Mocktail's
// `any` also collides with glados's `any` extension receiver, so mocktail is
// imported under the `mt` prefix and accessed as `mt.any()`, `mt.when(...)`,
// etc.

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart'
    hide expect, group, test, setUpAll, setUp, tearDown, tearDownAll;
import 'package:mocktail/mocktail.dart' as mt;
import 'package:rehab_path_app/core/errors/failures.dart';
import 'package:rehab_path_app/core/usecases/use_case.dart';
import 'package:rehab_path_app/core/utils/date_utils.dart';
import 'package:rehab_path_app/features/exercise/domain/usecases/get_exercises_by_level_use_case.dart';
import 'package:rehab_path_app/features/exercise/domain/usecases/get_schedule_for_date_use_case.dart';
import 'package:rehab_path_app/features/home/domain/usecases/get_random_message_use_case.dart';
import 'package:rehab_path_app/features/home/domain/usecases/get_streak_use_case.dart';
import 'package:rehab_path_app/features/home/domain/usecases/get_today_schedule_use_case.dart';
import 'package:rehab_path_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:rehab_path_app/features/home/presentation/cubit/home_state.dart';
import 'package:rehab_path_app/shared/data/datasources/hive_data_source.dart';
import 'package:rehab_path_app/shared/data/models/exercise_session_hive_model.dart';
import 'package:rehab_path_app/shared/domain/entities/exercise_entity.dart';
import 'package:rehab_path_app/shared/domain/entities/motivational_message_entity.dart';
import 'package:rehab_path_app/shared/domain/entities/user_entity.dart';
import 'package:rehab_path_app/shared/domain/enums/app_enums.dart';

// ── Mocks ────────────────────────────────────────────────────────────────────

class _MockGetRandomMessageUseCase extends mt.Mock
    implements GetRandomMessageUseCase {}

class _MockGetStreakUseCase extends mt.Mock implements GetStreakUseCase {}

class _MockGetTodayScheduleUseCase extends mt.Mock
    implements GetTodayScheduleUseCase {}

class _MockGetExercisesByLevelUseCase extends mt.Mock
    implements GetExercisesByLevelUseCase {}

class _MockGetScheduleForDateUseCase extends mt.Mock
    implements GetScheduleForDateUseCase {}

class _MockHiveDataSource extends mt.Mock implements HiveDataSource {}

// ── Fixtures ─────────────────────────────────────────────────────────────────

/// A fixed today schedule of four exercises. Their ids form the "in-schedule"
/// id set used by both the production aggregation logic and the property
/// assertions.
const _todayScheduleIds = <String>[
  'in_0',
  'in_1',
  'in_2',
  'in_3',
];

/// Out-of-schedule ids — sessions tagged with these must NOT bump
/// `completedToday`, but MUST still appear in `totalSessions`.
const _outOfScheduleIds = <String>[
  'out_0',
  'out_1',
  'out_2',
  'out_3',
];

/// All ids the session generator may pick from. Mixing both pools per
/// generator iteration keeps the property test honest.
const _idPool = <String>[..._todayScheduleIds, ..._outOfScheduleIds];

ExerciseEntity _exercise(String id) => ExerciseEntity(
      id: id,
      name: id,
      category: ExerciseCategory.warmUp,
      description: 'desc-$id',
      steps: const ['step'],
      durationSeconds: 60,
      sets: 1,
      reps: 1,
      difficulty: 1,
      safetyTips: const [],
      imagePath: '',
      recommendedLevel: ProgramLevel.beginner,
    );

List<ExerciseEntity> _todaySchedule() =>
    _todayScheduleIds.map(_exercise).toList(growable: false);

UserEntity _user() => const UserEntity(
      id: 'user_1',
      name: 'Test User',
      phoneNumber: '+6281234567890',
      age: 70,
      gender: 'female',
      programLevel: ProgramLevel.beginner,
      healthConditions: <String>[],
      emergencyContacts: [],
    );

const _fixedMessage = MotivationalMessageEntity(
  id: 'm1',
  textEn: 'Keep going!',
  textId: 'Terus semangat!',
  category: 'encouragement',
);

/// A timestamp guaranteed to be strictly after `AppDateUtils.todayLocal()`.
/// `loadDashboard` uses `s.completedAt.isAfter(todayStart)` where
/// `todayStart = todayLocal()` (midnight); midday today satisfies that.
DateTime _todayMidday() {
  final today = AppDateUtils.todayLocal();
  return today.add(const Duration(hours: 12));
}

ExerciseSessionHiveModel _session({
  required String id,
  required String exerciseId,
  required String userId,
  required DateTime completedAt,
}) =>
    ExerciseSessionHiveModel(
      id: id,
      exerciseId: exerciseId,
      userId: userId,
      completedAt: completedAt,
      bodyCondition: BodyCondition.standing.name,
      supportUsed: SupportUsed.noSupport.name,
    );

/// Wires up a fresh cubit with stub-backed collaborators. The hive datasource
/// returns [sessions] from `getAllSessions()`. The today-schedule use case
/// always returns the four fixed in-schedule exercises. The schedule-for-date
/// use case is configured per-test through [scheduleForDate], defaulting to
/// the same today schedule for any input date.
({
  HomeCubit cubit,
  _MockHiveDataSource hive,
  _MockGetScheduleForDateUseCase scheduleForDate,
}) _buildCubit({
  List<ExerciseSessionHiveModel> sessions = const [],
  int streak = 0,
  List<ExerciseEntity>? todaySchedule,
  Either<Failure, List<ExerciseEntity>> Function(DateTime date)?
      scheduleForDateFold,
}) {
  final message = _MockGetRandomMessageUseCase();
  final streakUc = _MockGetStreakUseCase();
  final todayUc = _MockGetTodayScheduleUseCase();
  final byLevelUc = _MockGetExercisesByLevelUseCase();
  final scheduleForDateUc = _MockGetScheduleForDateUseCase();
  final hive = _MockHiveDataSource();

  final schedule = todaySchedule ?? _todaySchedule();

  mt
      .when(() => message(mt.any()))
      .thenAnswer((_) async => Right(_fixedMessage));
  mt.when(() => streakUc(mt.any())).thenAnswer((_) async => Right(streak));
  mt.when(() => todayUc(mt.any())).thenAnswer((_) async => Right(schedule));
  mt
      .when(() => byLevelUc(mt.any()))
      .thenAnswer((_) async => const Right(<ExerciseEntity>[]));
  mt.when(() => scheduleForDateUc(mt.any())).thenAnswer((invocation) async {
    final params =
        invocation.positionalArguments.first as GetScheduleForDateParams;
    final fold = scheduleForDateFold;
    if (fold != null) {
      return fold(params.date);
    }
    return Right(schedule);
  });

  mt.when(hive.getAllSessions).thenReturn(sessions);

  final cubit = HomeCubit(
    message,
    streakUc,
    todayUc,
    byLevelUc,
    scheduleForDateUc,
    hive,
  );

  return (
    cubit: cubit,
    hive: hive,
    scheduleForDate: scheduleForDateUc,
  );
}

// ── Glados generators ────────────────────────────────────────────────────────

/// A single generated session description: which id from [_idPool] to use.
/// Decoupled from absolute timestamps because sessions in property 9 share
/// the same "midday today" time.
typedef _SessionSeed = ({int index, int idPick});

/// Inputs for property 9: a list of session seeds.
typedef _Property9Input = List<_SessionSeed>;

/// Inputs for property 10: a `(completed, scheduleLength)` pair across the
/// realistic ranges from the design.
typedef _Property10Input = ({int completed, int scheduleLength});

/// Inputs for property 13: a day-offset relative to today.
typedef _Property13Input = ({int dayOffset, int sessionCount});

extension _HomeAnys on Any {
  /// `(index, idPick)` — index keeps session ids unique within a list,
  /// idPick selects from the mixed in/out-of-schedule pool.
  Generator<_SessionSeed> get sessionSeed =>
      combine2(intInRange(0, 1 << 16), intInRange(0, _idPool.length),
          (int index, int pick) => (index: index, idPick: pick));

  /// Up to ~12 session seeds — keeps each iteration fast while still
  /// exercising mixes that include zero, all-in, all-out, and split lists.
  Generator<_Property9Input> get property9Input =>
      listWithLengthInRange(0, 13, sessionSeed);

  Generator<_Property10Input> get property10Input => combine2(
        intInRange(0, 21), // completed
        intInRange(0, 7), // schedule length
        (int c, int len) => (completed: c, scheduleLength: len),
      );

  Generator<_Property13Input> get property13Input => combine2(
        intInRange(-30, 31),
        intInRange(0, 9),
        (int o, int s) => (dayOffset: o, sessionCount: s),
      );
}

// ── Helpers ──────────────────────────────────────────────────────────────────

/// Drives `loadDashboard` to completion and returns the loaded data.
Future<HomeData> _loadAndAwait(HomeCubit cubit, UserEntity user) async {
  await cubit.loadDashboard(user);
  final state = cubit.state;
  expect(state, isA<HomeLoaded>());
  return (state as HomeLoaded).data;
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() {
    // Mocktail fallbacks for non-nullable positional args used with `mt.any()`.
    mt.registerFallbackValue(const NoParams());
    mt.registerFallbackValue(const GetStreakParams(userId: '_fallback'));
    mt.registerFallbackValue(
      const GetTodayScheduleParams(userId: '_fallback'),
    );
    mt.registerFallbackValue(
      const GetExercisesByLevelParams(ProgramLevel.beginner),
    );
    mt.registerFallbackValue(
      GetScheduleForDateParams(userId: '_fallback', date: DateTime(2024)),
    );
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Property 9 (task 10.4): Dashboard aggregation only counts in-schedule
  // sessions.
  // **Validates: Requirements 6.2, 6.3**
  // ───────────────────────────────────────────────────────────────────────────
  group(
      'Property 9: Dashboard aggregation only counts in-schedule sessions',
      () {
    Glados<_Property9Input>(any.property9Input).test(
      'completedToday equals the count of sessions whose exerciseId is in '
      "today's schedule, while totalSessions still includes out-of-schedule "
      'sessions',
      (seeds) async {
        final user = _user();
        final inSet = _todayScheduleIds.toSet();
        final completedAt = _todayMidday();

        // Materialize seeds into actual session models. Use the seed index
        // to disambiguate ids so two seeds with the same idPick still yield
        // distinct primary keys.
        final sessions = <ExerciseSessionHiveModel>[
          for (var i = 0; i < seeds.length; i++)
            _session(
              id: 'session_${seeds[i].index}_$i',
              exerciseId: _idPool[seeds[i].idPick],
              userId: user.id,
              completedAt: completedAt,
            ),
        ];

        final wired = _buildCubit(sessions: sessions);

        final data = await _loadAndAwait(wired.cubit, user);

        final expectedCompletedToday =
            sessions.where((s) => inSet.contains(s.exerciseId)).length;

        // R6.2 / R6.3 — only in-schedule sessions affect the aggregation.
        expect(
          data.completedToday,
          equals(expectedCompletedToday),
          reason: 'completedToday must count only sessions whose exerciseId '
              'is in todaySchedule. Sessions: '
              '${sessions.map((s) => s.exerciseId).toList()}',
        );

        // Out-of-schedule sessions still count toward totalSessions per
        // design.md ("Out-of-schedule sessions still saved in Hive but
        // ignored in aggregation").
        expect(
          data.totalSessions,
          equals(sessions.length),
          reason: 'totalSessions must include every session saved in Hive, '
              'including out-of-schedule ones',
        );

        // The selected-date view is initialized to today, so its completed
        // count must match completedToday.
        expect(data.selectedDateCompleted, equals(expectedCompletedToday));
        expect(data.selectedDateSchedule.length,
            equals(_todayScheduleIds.length));

        await wired.cubit.close();
      },
    );
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Property 10 (task 10.5): Progress ring percent matches the formula.
  // **Validates: Requirements 6.4, 9.7**
  // ───────────────────────────────────────────────────────────────────────────
  group('Property 10: Progress ring percent matches the formula', () {
    Glados<_Property10Input>(any.property10Input).test(
      'progressRingPercent equals (completed / scheduleLen * 100).round() '
      'when scheduleLen > 0, and 0 when scheduleLen == 0',
      (input) {
        final today = AppDateUtils.todayLocal();
        final selectedDateSchedule = <ExerciseEntity>[
          for (var i = 0; i < input.scheduleLength; i++) _exercise('e_$i'),
        ];

        final data = HomeData(
          user: _user(),
          streakDays: 0,
          todaySchedule: const [],
          completedToday: 0,
          recommendedExercises: const [],
          motivationalMessage: _fixedMessage,
          completedDaysThisWeek: const [],
          totalMinutes: 0,
          totalSessions: 0,
          selectedDate: today,
          todayLocal: today,
          selectedDateSchedule: selectedDateSchedule,
          selectedDateCompleted: input.completed,
        );

        final expected = input.scheduleLength == 0
            ? 0
            : ((input.completed / input.scheduleLength) * 100).round();

        expect(
          data.progressRingPercent,
          equals(expected),
          reason: 'completed=${input.completed}, '
              'scheduleLen=${input.scheduleLength}: '
              'expected $expected, got ${data.progressRingPercent}',
        );

        // Schedule-length-zero short-circuit must always be 0 regardless of
        // completed (no division by zero, no >100 leakage).
        if (input.scheduleLength == 0) {
          expect(data.progressRingPercent, equals(0));
        }
      },
    );
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Property 13 (task 10.6): View-mode is read-only and leaves the persistent
  // state untouched.
  // **Validates: Requirements 9.4, 9.6, 9.8**
  // ───────────────────────────────────────────────────────────────────────────
  group(
      'Property 13: View-mode is read-only and leaves the persistent state '
      'untouched', () {
    Glados<_Property13Input>(any.property13Input).test(
      'selectDate(targetDate) preserves completedToday, streakDays, '
      'totalSessions, totalMinutes, completedDaysThisWeek; future dates '
      'yield empty selectedDateSchedule and 0 selectedDateCompleted',
      (input) async {
        final user = _user();
        final completedAt = _todayMidday();

        // Pre-seed sessions covering both pools so the initial loaded state
        // has non-zero metrics. Spreading via modulo keeps the in/out mix
        // varied across iterations.
        final sessions = <ExerciseSessionHiveModel>[
          for (var i = 0; i < input.sessionCount; i++)
            _session(
              id: 'session_$i',
              exerciseId: _idPool[i % _idPool.length],
              userId: user.id,
              completedAt: completedAt,
            ),
        ];

        final wired = _buildCubit(
          sessions: sessions,
          streak: 7,
          // selectDate(future) is short-circuited inside the cubit and
          // never invokes this stub, so always returning today's schedule
          // for any non-future date is safe.
          scheduleForDateFold: (date) => Right(_todaySchedule()),
        );

        // Pre-load → captures the initial loaded state.
        final initial = await _loadAndAwait(wired.cubit, user);

        // Target date relative to today. dayOffset > 0 → future, < 0 → past,
        // 0 → today.
        final today = AppDateUtils.todayLocal();
        final targetDate = today.add(Duration(days: input.dayOffset));
        final isFuture = targetDate.isAfter(today);

        await wired.cubit.selectDate(targetDate);

        final state = wired.cubit.state;
        expect(state, isA<HomeLoaded>());
        final after = (state as HomeLoaded).data;

        // R9.8 — totals and per-day-of-week metrics MUST be untouched.
        expect(
          after.completedToday,
          equals(initial.completedToday),
          reason: 'completedToday must not change in view-mode',
        );
        expect(
          after.streakDays,
          equals(initial.streakDays),
          reason: 'streakDays must not change in view-mode',
        );
        expect(
          after.totalSessions,
          equals(initial.totalSessions),
          reason: 'totalSessions must not change in view-mode',
        );
        expect(
          after.totalMinutes,
          equals(initial.totalMinutes),
          reason: 'totalMinutes must not change in view-mode',
        );
        expect(
          after.completedDaysThisWeek,
          equals(initial.completedDaysThisWeek),
          reason: 'completedDaysThisWeek must not change in view-mode',
        );

        // selectedDate is normalized to local-midnight before being stored.
        expect(
          after.selectedDate,
          equals(AppDateUtils.toLocalMidnight(targetDate)),
        );

        // R9.6 — future dates show no schedule and no completion.
        if (isFuture) {
          expect(
            after.selectedDateSchedule,
            isEmpty,
            reason: 'Future date must yield an empty selectedDateSchedule',
          );
          expect(
            after.selectedDateCompleted,
            equals(0),
            reason: 'Future date must yield selectedDateCompleted == 0',
          );
          expect(
            after.progressRingPercent,
            equals(0),
            reason: 'Future date must show a 0% ring',
          );
        }

        await wired.cubit.close();
      },
    );
  });
}
