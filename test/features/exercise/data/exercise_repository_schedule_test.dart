// Property-based tests for [ExerciseRepositoryImpl.getScheduleForDate].
//
// This file is the home for the schedule-shape and schedule-determinism
// properties from `.kiro/specs/app-flow-adjustments/design.md`:
//
//   * Property 11 (task 8.7): Schedule selection is deterministic per
//     (userId, date) and varies across distinct dates.
//     **Validates: Requirements 7.1, 7.2, 7.3**
//
//   * Property 12 (task 8.8): Schedule shape obeys length and category
//     bounds. **Validates: Requirements 7.4, 7.5**
//
// Test strategy
// -------------
// `ExerciseRepositoryImpl` depends on three collaborators:
//   * [DummyDataSource]   — supplies the exercise catalogue.
//   * [HiveDataSource]    — supplies the user record + on-disk schedule cache.
//   * [Logger]            — pure side-effect.
//
// Each of those is faked with `mocktail`. The catalogue we hand to the fake
// has full category coverage (warm-up / body / cool-down) and at least 6
// level-matching entries, which is the "sufficient catalogue" precondition
// described in tasks 8.7 and 8.8.
//
// Glados drives variation across `(userId, dayOffset, weeklyFrequencyTarget)`
// with ≥ 100 iterations per property; for each tuple we build a fresh
// repository instance to keep the explorations hermetic.
//
// Import note: glados re-exports `package:test_core/scaffolding.dart`, which
// collides with `flutter_test`'s `setUpAll`/`group`/`test`/`expect`. We keep
// the `flutter_test` versions (so widget-test infrastructure stays available
// if added later) and hide the duplicates from `glados`. Mocktail's `any`
// also collides with glados's `any` extension receiver, so mocktail is
// imported under the `mt` prefix and accessed as `mt.any()`, `mt.when(...)`,
// etc.

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart'
    hide expect, group, test, setUpAll, setUp, tearDown, tearDownAll;
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart' as mt;
import 'package:laman_lansia/features/exercise/data/repositories/exercise_repository_impl.dart';
import 'package:laman_lansia/features/exercise/data/utils/schedule_seed_generator.dart';
import 'package:laman_lansia/shared/data/datasources/dummy_data_source.dart';
import 'package:laman_lansia/shared/data/datasources/hive_data_source.dart';
import 'package:laman_lansia/shared/data/models/onboarding_profile_hive_model.dart';
import 'package:laman_lansia/shared/data/models/user_hive_model.dart';
import 'package:laman_lansia/shared/domain/entities/exercise_entity.dart';
import 'package:laman_lansia/shared/domain/enums/app_enums.dart';

// ── Mocks ────────────────────────────────────────────────────────────────────

class _MockDummyDataSource extends mt.Mock implements DummyDataSource {}

class _MockHiveDataSource extends mt.Mock implements HiveDataSource {}

class _MockLogger extends mt.Mock implements Logger {}

// ── Fixtures ─────────────────────────────────────────────────────────────────

const _testProgramLevel = ProgramLevel.beginner;

/// A catalogue with full category coverage and ample variety to keep the
/// seeded output space large:
///   * 16 warm-ups
///   * 64 body items spanning balance / strength / endurance / tai-chi /
///     walking / floor recovery
///   * 16 cool-downs
///
/// All entries are tagged with [_testProgramLevel] so every catalogue entry
/// is selectable. Two off-level entries are appended to make sure
/// `recommendedLevel` filtering is exercised — they must never appear in
/// the returned schedule.
///
/// Why so large? With `targetCount = 4` the algorithm picks one warm-up,
/// one cool-down, and the first two items of a seeded shuffle of the body
/// pool. The number of distinct ordered outputs is therefore at least
/// `16 * 16 * 64 * 63 ≈ 1,032,192`, which keeps the probability of two
/// distinct seeds producing identical schedules below ~0.0001 per pair.
/// Combined with the explicit seed-collision skip in the property body,
/// that gives Properties 11b/c essentially zero false-positive risk over
/// 100 Glados iterations.
List<ExerciseEntity> _buildCatalogue() {
  ExerciseEntity ex(
    String id,
    ExerciseCategory cat, {
    ProgramLevel level = _testProgramLevel,
  }) =>
      ExerciseEntity(
        id: id,
        name: id,
        category: cat,
        description: 'desc-$id',
        steps: const ['step'],
        durationSeconds: 60,
        sets: 1,
        reps: 1,
        difficulty: 1,
        safetyTips: const [],
        imagePath: '',
        recommendedLevel: level,
      );

  const bodyCategories = <ExerciseCategory>[
    ExerciseCategory.balanceTraining,
    ExerciseCategory.strengthTraining,
    ExerciseCategory.enduranceAerobic,
    ExerciseCategory.taiChi,
    ExerciseCategory.walkingProgram,
    ExerciseCategory.gettingUpFromFloor,
  ];

  return <ExerciseEntity>[
    for (var i = 0; i < 16; i++) ex('warm_$i', ExerciseCategory.warmUp),
    for (var i = 0; i < 64; i++)
      ex('body_$i', bodyCategories[i % bodyCategories.length]),
    for (var i = 0; i < 16; i++) ex('cool_$i', ExerciseCategory.coolDown),
    // Off-level decoys — must be filtered out by `recommendedLevel`.
    ex('decoy_balance', ExerciseCategory.balanceTraining,
        level: ProgramLevel.advanced),
    ex('decoy_warm', ExerciseCategory.warmUp,
        level: ProgramLevel.intermediate),
  ];
}

UserHiveModel _buildUser({
  required String userId,
  int? weeklyFrequencyTarget,
}) {
  OnboardingProfileHiveModel? profile;
  if (weeklyFrequencyTarget != null) {
    profile = OnboardingProfileHiveModel(
      age: 70,
      gender: 'female',
      fallsInLastYear: 0,
      healthConditions: const [],
      usesWalkingAid: false,
      fearOfFallingScore: 5,
      preferredExerciseTime: 'morning',
      sessionDurationMinutes: 20,
      weeklyFrequencyTarget: weeklyFrequencyTarget,
      outcomeGoal: 'goal',
      behaviouralGoal: 'b_goal',
      programLevel: _testProgramLevel.name,
      lastCompletedStep: null,
    );
  }

  return UserHiveModel(
    id: userId,
    name: 'user-$userId',
    email: '',
    age: 70,
    gender: 'female',
    programLevel: _testProgramLevel.name,
    healthConditions: const [],
    emergencyContacts: const [],
    phoneNumber: '+6281234567890',
    avatarPath: null,
    onboardingProfile: profile,
  );
}

/// Wires up a fresh repository whose datasource fakes return the supplied
/// catalogue + user. The Hive schedule cache always reports a miss so the
/// code path under test always exercises the seeded computation.
({
  ExerciseRepositoryImpl repo,
  _MockHiveDataSource hive,
}) _buildRepository({
  required List<ExerciseEntity> catalogue,
  required UserHiveModel user,
}) {
  final dummy = _MockDummyDataSource();
  final hive = _MockHiveDataSource();
  final logger = _MockLogger();

  mt.when(dummy.loadExercises).thenAnswer((_) async => catalogue);
  // Use a permissive matcher so any userId Glados generates resolves to the
  // same user fixture; this keeps the property test focused on the seeding
  // contract rather than user lookup wiring.
  mt
      .when(() => hive.getUser(mt.any()))
      .thenAnswer((invocation) {
    final id = invocation.positionalArguments.first as String;
    return id == user.id ? user : _buildUser(userId: id);
  });
  mt
      .when(() => hive.getScheduleSet(mt.any(), mt.any()))
      .thenAnswer((_) async => null);
  mt.when(
    () => hive.saveScheduleSet(
      userId: mt.any(named: 'userId'),
      date: mt.any(named: 'date'),
      exerciseIds: mt.any(named: 'exerciseIds'),
    ),
  ).thenAnswer((_) async {});

  // The mocked logger has nothing observable to assert; stubbing nothing is
  // fine because every Logger method has a void return.

  return (
    repo: ExerciseRepositoryImpl(dummy, hive, logger),
    hive: hive,
  );
}

/// Convenience: run `getScheduleForDate` and project to the id list, failing
/// fast if the repository returns a [Failure].
Future<List<String>> _scheduleIdsFor(
  ExerciseRepositoryImpl repo,
  String userId,
  DateTime date,
) async {
  final result = await repo.getScheduleForDate(userId: userId, date: date);
  return result.fold(
    (failure) =>
        throw StateError('Unexpected failure for ($userId, $date): $failure'),
    (list) => list.map((e) => e.id).toList(),
  );
}

// ── Glados generators ────────────────────────────────────────────────────────

extension _ScheduleAnys on Any {
  /// User ids in the regular `user_<n>` shape, with enough cardinality to
  /// drive distinct seeds. We stay short and ASCII so failure shrinking
  /// produces tractable counter-examples.
  Generator<String> get scheduleUserId =>
      intInRange(0, 1024).map((n) => 'user_$n');

  /// Day-offset in `[-365, 365]` relative to a fixed reference date. We
  /// avoid `DateTime.now()` so glados explorations are reproducible across
  /// runs.
  Generator<int> get dayOffset => intInRange(-365, 366);

  /// `weeklyFrequencyTarget` drawn from `[1, 10]` so we exercise both ends
  /// of the implementation's `clamp(3, 6)` plus the in-range middle.
  Generator<int> get weeklyFrequencyTarget => intInRange(1, 11);
}

DateTime _dateForOffset(int dayOffset) {
  // Reference: 2024-01-01 local midnight. Stable across runs.
  return DateTime(2024, 1, 1).add(Duration(days: dayOffset));
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() {
    // `mocktail` needs a fallback for non-nullable positional args used with
    // `mt.any()`. The schedule cache lookup takes a `DateTime` and the cache
    // writer takes a `List<String>`.
    mt.registerFallbackValue(DateTime(2024));
    mt.registerFallbackValue(<String>[]);
  });

  group(
      'Property 11: Schedule selection is deterministic per (userId, date) '
      'and varies across distinct dates', () {
    // ─── Property 11a: determinism ───────────────────────────────────────
    //
    // For arbitrary `(userId, dayOffset)`, calling `getScheduleForDate`
    // twice on a fresh repository instance must return the same id list in
    // the same order. We use a fresh repo for each call so the in-memory
    // cache cannot trivially satisfy the property — only the seed-derived
    // computation can.
    Glados2<String, int>(
      any.scheduleUserId,
      any.dayOffset,
    ).test(
      'is deterministic per (userId, date) — same list on repeated calls',
      (userId, dayOffset) async {
        final date = _dateForOffset(dayOffset);

        final firstWired = _buildRepository(
          catalogue: _buildCatalogue(),
          user: _buildUser(userId: userId, weeklyFrequencyTarget: 4),
        );
        final secondWired = _buildRepository(
          catalogue: _buildCatalogue(),
          user: _buildUser(userId: userId, weeklyFrequencyTarget: 4),
        );

        final first = await _scheduleIdsFor(firstWired.repo, userId, date);
        final second = await _scheduleIdsFor(secondWired.repo, userId, date);

        expect(
          second,
          equals(first),
          reason: 'Schedules for the same (userId=$userId, dayOffset='
              '$dayOffset) must match exactly across calls.',
        );
      },
    );

    // ─── Property 11b: variation across distinct dates ───────────────────
    //
    // For the same userId and two distinct dates the schedules must NOT be
    // identical sequences (length-or-ids differ). With 4 body items in the
    // catalogue and `targetCount = 4`, the seeded shuffle has at least
    // 4! = 24 distinct outcomes for the body slice plus 2×2 bookend choices
    // ⇒ the probability of a coincidental collision across two random seeds
    // is well below 1% per pair. Glados's 100 iterations comfortably stay
    // within that envelope.
    Glados3<String, int, int>(
      any.scheduleUserId,
      any.dayOffset,
      any.dayOffset,
    ).test(
      'varies across distinct dates for the same user',
      (userId, dayOffsetA, dayOffsetB) async {
        if (dayOffsetA == dayOffsetB) return; // skip duplicate-date inputs

        // The variation guarantee depends on `(userId, dayKey)` producing
        // distinct seeds; when `Object.hash` happens to collide on two
        // distinct inputs the algorithm has no way to differentiate the
        // schedules, which is a Dart-hash corner rather than a schedule
        // bug. Skip those inputs.
        final dateA = _dateForOffset(dayOffsetA);
        final dateB = _dateForOffset(dayOffsetB);
        final seedA = ScheduleSeedGenerator.seed(userId, dateA);
        final seedB = ScheduleSeedGenerator.seed(userId, dateB);
        if (seedA == seedB) return;

        final wired = _buildRepository(
          catalogue: _buildCatalogue(),
          user: _buildUser(userId: userId, weeklyFrequencyTarget: 4),
        );

        final scheduleA = await _scheduleIdsFor(wired.repo, userId, dateA);
        final scheduleB = await _scheduleIdsFor(wired.repo, userId, dateB);

        final differs = scheduleA.length != scheduleB.length ||
            !_listEquals(scheduleA, scheduleB);
        expect(
          differs,
          isTrue,
          reason:
              'Expected schedules for the same user on distinct dates to '
              'differ by length or id sequence.\n'
              '  userId      : $userId\n'
              '  dayOffsetA  : $dayOffsetA -> $scheduleA\n'
              '  dayOffsetB  : $dayOffsetB -> $scheduleB',
        );
      },
    );

    // ─── Property 11c: variation across distinct users on the same date ──
    //
    // Same-date, distinct-userId schedules must NOT be identical sequences.
    // The seed combines `(userId, dayKey)` via `Object.hash`, so distinct
    // userIds yield distinct seeds and the same probabilistic argument as
    // 11b applies.
    Glados3<String, String, int>(
      any.scheduleUserId,
      any.scheduleUserId,
      any.dayOffset,
    ).test(
      'varies across distinct users on the same date',
      (userIdA, userIdB, dayOffset) async {
        if (userIdA == userIdB) return; // skip duplicate-user inputs

        final date = _dateForOffset(dayOffset);
        final seedA = ScheduleSeedGenerator.seed(userIdA, date);
        final seedB = ScheduleSeedGenerator.seed(userIdB, date);
        // See Property 11b for the rationale on hash-collision skips.
        if (seedA == seedB) return;

        final wiredA = _buildRepository(
          catalogue: _buildCatalogue(),
          user: _buildUser(userId: userIdA, weeklyFrequencyTarget: 4),
        );
        final wiredB = _buildRepository(
          catalogue: _buildCatalogue(),
          user: _buildUser(userId: userIdB, weeklyFrequencyTarget: 4),
        );

        final scheduleA = await _scheduleIdsFor(wiredA.repo, userIdA, date);
        final scheduleB = await _scheduleIdsFor(wiredB.repo, userIdB, date);

        final differs = scheduleA.length != scheduleB.length ||
            !_listEquals(scheduleA, scheduleB);
        expect(
          differs,
          isTrue,
          reason:
              'Expected schedules for distinct users on the same date to '
              'differ by length or id sequence.\n'
              '  userIdA   : $userIdA -> $scheduleA\n'
              '  userIdB   : $userIdB -> $scheduleB\n'
              '  dayOffset : $dayOffset',
        );
      },
    );
  });

  group('Property 12: Schedule shape obeys length and category bounds', () {
    // ─── Property 12a: shape under varied weeklyFrequencyTarget ──────────
    //
    // For arbitrary `(userId, dayOffset, weeklyFrequencyTarget)`, with a
    // sufficient catalogue (≥ 6 level-matching entries with full category
    // coverage), the returned schedule must:
    //   * have length in `[3, 6]` (clamped to 6 even when target = 10),
    //   * start with a `warmUp`,
    //   * end with a `coolDown`,
    //   * draw only from the level-matching slice of the catalogue.
    Glados3<String, int, int>(
      any.scheduleUserId,
      any.dayOffset,
      any.weeklyFrequencyTarget,
    ).test(
      'returns 3-6 items, warmUp first and coolDown last, level-filtered',
      (userId, dayOffset, weeklyTarget) async {
        final catalogue = _buildCatalogue();
        final user = _buildUser(
          userId: userId,
          weeklyFrequencyTarget: weeklyTarget,
        );
        final wired = _buildRepository(catalogue: catalogue, user: user);

        final result = await wired.repo.getScheduleForDate(
          userId: userId,
          date: _dateForOffset(dayOffset),
        );

        expect(result, isA<Right<dynamic, List<ExerciseEntity>>>());
        final schedule = result.getOrElse(() => const []);

        // Length envelope.
        expect(
          schedule.length,
          inInclusiveRange(3, 6),
          reason: 'weeklyTarget=$weeklyTarget produced ${schedule.length} '
              'items for userId=$userId dayOffset=$dayOffset',
        );

        // Bookends — the catalogue contains both warm-ups and cool-downs at
        // the requested level, so the precondition for R7.5 holds.
        expect(schedule.first.category, ExerciseCategory.warmUp);
        expect(schedule.last.category, ExerciseCategory.coolDown);

        // Level filter — decoys must never leak through.
        for (final ex in schedule) {
          expect(ex.recommendedLevel, _testProgramLevel);
          expect(ex.id, isNot(startsWith('decoy_')));
        }
      },
    );

    // ─── Property 12b: weeklyFrequencyTarget → exact length mapping ──────
    //
    // The design fixes four reference points the property exploration alone
    // would not reliably hit (clamp boundaries and the no-profile default).
    // These are pinned as parameterised example tests — Glados explorations
    // above cover the rest of the input space.
    final lengthMappings = <({int? weeklyTarget, int expectedLength})>[
      (weeklyTarget: 3, expectedLength: 3),
      (weeklyTarget: 6, expectedLength: 6),
      (weeklyTarget: 10, expectedLength: 6), // clamped to 6
      (weeklyTarget: null, expectedLength: 4), // default when no profile
    ];

    for (final mapping in lengthMappings) {
      final label = mapping.weeklyTarget == null
          ? 'no onboarding profile'
          : 'weeklyFrequencyTarget=${mapping.weeklyTarget}';

      test('schedule length is ${mapping.expectedLength} when $label',
          () async {
        final catalogue = _buildCatalogue();
        final user = _buildUser(
          userId: 'user_mapping',
          weeklyFrequencyTarget: mapping.weeklyTarget,
        );
        final wired = _buildRepository(catalogue: catalogue, user: user);

        final result = await wired.repo.getScheduleForDate(
          userId: 'user_mapping',
          date: DateTime(2024, 5, 15),
        );

        final schedule = result.getOrElse(() => const []);
        expect(schedule.length, mapping.expectedLength);
        expect(schedule.first.category, ExerciseCategory.warmUp);
        expect(schedule.last.category, ExerciseCategory.coolDown);
      });
    }

    // ─── Property 12c: small catalogue degrades gracefully ───────────────
    //
    // When the level-matching catalogue has fewer than 3 entries, the
    // schedule returns whatever is available rather than failing or padding.
    // Two slices cover the meaningful corners: one item, two items.
    test('catalogue with 1 level-matching item returns that one item',
        () async {
      final catalogue = <ExerciseEntity>[
        _buildCatalogue().firstWhere((e) => e.id == 'body_0'),
      ];
      final user = _buildUser(
        userId: 'user_small_one',
        weeklyFrequencyTarget: 4,
      );
      final wired = _buildRepository(catalogue: catalogue, user: user);

      final result = await wired.repo.getScheduleForDate(
        userId: 'user_small_one',
        date: DateTime(2024, 5, 15),
      );

      final schedule = result.getOrElse(() => const []);
      expect(schedule, hasLength(1));
      expect(schedule.single.id, 'body_0');
    });

    test(
        'catalogue with 1 warm-up + 1 cool-down (no body) returns just those '
        'two with warmUp first and coolDown last', () async {
      final all = _buildCatalogue();
      final catalogue = <ExerciseEntity>[
        all.firstWhere((e) => e.id == 'warm_0'),
        all.firstWhere((e) => e.id == 'cool_0'),
      ];
      final user = _buildUser(
        userId: 'user_small_two',
        weeklyFrequencyTarget: 4,
      );
      final wired = _buildRepository(catalogue: catalogue, user: user);

      final result = await wired.repo.getScheduleForDate(
        userId: 'user_small_two',
        date: DateTime(2024, 5, 15),
      );

      final schedule = result.getOrElse(() => const []);
      expect(schedule, hasLength(2));
      expect(schedule.first.category, ExerciseCategory.warmUp);
      expect(schedule.last.category, ExerciseCategory.coolDown);
    });
  });
}

bool _listEquals(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
