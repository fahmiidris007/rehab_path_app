// Property-based and example tests for [ExerciseListCubit].
//
// This file covers task 9.4 of `.kiro/specs/app-flow-adjustments/tasks.md`:
//
//   * Property 8 (task 9.4): Exercise list mode contract.
//     **Validates: Requirements 5.1, 5.3, 5.6**
//
// Test strategy
// -------------
// `ExerciseListCubit` collaborates with two use cases:
//   * [GetTodayScheduleUseCase] — supplies the today-mode list.
//   * [GetAllExercisesUseCase]  — supplies the all-mode list.
//
// Both are faked with `mocktail` so we exercise the cubit end-to-end without
// touching Hive, the repository, or DI. Each property iteration constructs a
// fresh cubit + fresh mocks so state transitions are hermetic.
//
// Property 8 drives variation across:
//   * the list of exercises returned by each use case (length 0–6),
//   * the length of the alternating-switch sequence (0–8 toggles after the
//     mandatory `loadInitial`).
//
// After replaying the sequence the final state MUST match the last
// operation's expected mode and carry exactly the use case payload.
//
// Two example tests pin down behaviour the property exploration alone might
// shrink past:
//
//   * `loadInitial(userId)` emits `ExerciseListLoading` then
//     `ExerciseListTodayMode(todaySchedule)` on a `Right` from the use case.
//   * Both `loadInitial` and `switchToAllMode` emit `ExerciseListError`
//     when their use cases return a `Left`.
//
// Import note: glados re-exports `package:test_core/scaffolding.dart`, which
// collides with `flutter_test`'s `setUpAll`/`group`/`test`/`expect`. We keep
// the `flutter_test` versions and hide the duplicates from glados. Mocktail's
// `any` collides with glados's `any` extension receiver, so mocktail is
// imported under the `mt` prefix.

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart'
    hide expect, group, test, setUpAll, setUp, tearDown, tearDownAll;
import 'package:mocktail/mocktail.dart' as mt;
import 'package:rehab_path_app/core/errors/failures.dart';
import 'package:rehab_path_app/core/usecases/use_case.dart';
import 'package:rehab_path_app/features/exercise/domain/usecases/get_all_exercises_use_case.dart';
import 'package:rehab_path_app/features/exercise/domain/usecases/get_today_schedule_use_case.dart';
import 'package:rehab_path_app/features/exercise/presentation/cubit/exercise_list_cubit.dart';
import 'package:rehab_path_app/features/exercise/presentation/cubit/exercise_list_state.dart';
import 'package:rehab_path_app/shared/domain/entities/exercise_entity.dart';
import 'package:rehab_path_app/shared/domain/enums/app_enums.dart';

// ── Mocks ────────────────────────────────────────────────────────────────────

class _MockGetTodayScheduleUseCase extends mt.Mock
    implements GetTodayScheduleUseCase {}

class _MockGetAllExercisesUseCase extends mt.Mock
    implements GetAllExercisesUseCase {}

// ── Fixtures ─────────────────────────────────────────────────────────────────

const _userId = 'user-1';

ExerciseEntity _ex(String id) => ExerciseEntity(
      id: id,
      name: id,
      category: ExerciseCategory.balanceTraining,
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

/// Wires fresh use case mocks and an [ExerciseListCubit] returning the given
/// payloads. Stubs are set with the exact param object the cubit forwards so
/// `mt.any()` matchers are not needed.
({
  ExerciseListCubit cubit,
  _MockGetTodayScheduleUseCase today,
  _MockGetAllExercisesUseCase all,
}) _wire({
  required List<ExerciseEntity> todayList,
  required List<ExerciseEntity> allList,
}) {
  final today = _MockGetTodayScheduleUseCase();
  final all = _MockGetAllExercisesUseCase();

  mt
      .when(() => today(const GetTodayScheduleParams(_userId)))
      .thenAnswer((_) async => Right<Failure, List<ExerciseEntity>>(todayList));
  mt
      .when(() => all(const NoParams()))
      .thenAnswer((_) async => Right<Failure, List<ExerciseEntity>>(allList));

  return (
    cubit: ExerciseListCubit(today, all),
    today: today,
    all: all,
  );
}

// ── Operation model ──────────────────────────────────────────────────────────

/// One step in the property-test sequence. `loadInitial` and
/// `switchToTodayMode` end the cubit in `todayMode`; `switchToAllMode` ends
/// it in `allMode`.
enum _Op { loadInitial, switchToToday, switchToAll }

/// Builds the canonical alternating sequence the property tests:
///
///   `[loadInitial, switchToAllMode, switchToTodayMode, switchToAllMode, …]`
///
/// of length `1 + toggleCount` where `toggleCount ∈ [0, maxToggles]`.
List<_Op> _buildSequence(int toggleCount) {
  final ops = <_Op>[_Op.loadInitial];
  for (var i = 0; i < toggleCount; i++) {
    // Even toggles → switch to all; odd toggles → switch back to today.
    ops.add(i.isEven ? _Op.switchToAll : _Op.switchToToday);
  }
  return ops;
}

Future<void> _runSequence(ExerciseListCubit cubit, List<_Op> ops) async {
  for (final op in ops) {
    switch (op) {
      case _Op.loadInitial:
        await cubit.loadInitial(_userId);
      case _Op.switchToToday:
        await cubit.switchToTodayMode(_userId);
      case _Op.switchToAll:
        await cubit.switchToAllMode();
    }
  }
}

// ── Glados generators ────────────────────────────────────────────────────────

extension _ExerciseListAnys on Any {
  /// A single, identifiable exercise. Ids are short integers so failure
  /// shrinking surfaces tractable counter-examples.
  Generator<ExerciseEntity> get exercise =>
      intInRange(0, 1024).map((n) => _ex('e_$n'));

  /// 0–6 distinct exercises (the schedule envelope from R7.4).
  Generator<List<ExerciseEntity>> get exerciseList =>
      listWithLengthInRange(0, 7, exercise);

  /// 0–8 mode toggles applied after the mandatory `loadInitial`.
  Generator<int> get toggleCount => intInRange(0, 9);
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() {
    // Mocktail needs a fallback value for non-nullable `mt.any()` matchers
    // that might be used in other suites — none here, but registering keeps
    // the suite robust against future additions.
    mt.registerFallbackValue(const GetTodayScheduleParams(_userId));
    mt.registerFallbackValue(const NoParams());
  });

  group(
      'Property 8: Exercise list mode contract — final state matches the '
      'last operation', () {
    Glados3<List<ExerciseEntity>, List<ExerciseEntity>, int>(
      any.exerciseList,
      any.exerciseList,
      any.toggleCount,
    ).test(
      'after [loadInitial, switchToAll, switchToToday, …] the final state '
      'always reflects the last op and the use case payload',
      (todayList, allList, toggleCount) async {
        final wired = _wire(todayList: todayList, allList: allList);
        addTearDown(wired.cubit.close);

        final ops = _buildSequence(toggleCount);
        await _runSequence(wired.cubit, ops);

        final lastOp = ops.last;
        final finalState = wired.cubit.state;

        switch (lastOp) {
          case _Op.loadInitial:
          case _Op.switchToToday:
            expect(
              finalState,
              isA<ExerciseListTodayMode>(),
              reason: 'Sequence ${ops.map((o) => o.name).toList()} must end '
                  'in todayMode',
            );
            expect(
              (finalState as ExerciseListTodayMode).todaySchedule,
              equals(todayList),
              reason: 'todayMode state must carry the today use case payload',
            );
          case _Op.switchToAll:
            expect(
              finalState,
              isA<ExerciseListAllMode>(),
              reason: 'Sequence ${ops.map((o) => o.name).toList()} must end '
                  'in allMode',
            );
            expect(
              (finalState as ExerciseListAllMode).allExercises,
              equals(allList),
              reason: 'allMode state must carry the all use case payload',
            );
        }
      },
    );
  });

  group('ExerciseListCubit — example contract', () {
    // Note on Bloc/Cubit observation
    // ------------------------------
    // The cubit's initial state is already `ExerciseListState.loading()`,
    // so the leading `emit(loading)` inside `loadInitial`/`switchToAllMode`
    // is the same value as the constructor seed and is deduplicated by
    // `Cubit.emit`. We therefore observe the "Loading first" half of the
    // contract synchronously via `cubit.state` between the call and the
    // await, and the "then TodayMode/AllMode/Error" half via `cubit.state`
    // after the await resolves. This avoids the broadcast-stream microtask
    // delivery race that would make assertions on `cubit.stream` flaky.

    test(
        'loadInitial enters Loading first, then TodayMode(todaySchedule) on '
        'a Right — Validates Requirement 5.1', () async {
      final today = [_ex('a'), _ex('b'), _ex('c')];
      final wired = _wire(todayList: today, allList: const []);
      addTearDown(wired.cubit.close);

      // Initial state is `loading()`.
      expect(wired.cubit.state, isA<ExerciseListLoading>());

      // While the use case future is in-flight the state is still loading.
      final future = wired.cubit.loadInitial(_userId);
      expect(wired.cubit.state, isA<ExerciseListLoading>());

      await future;

      // After the use case resolves the cubit settles into todayMode.
      expect(wired.cubit.state, isA<ExerciseListTodayMode>());
      expect(
        (wired.cubit.state as ExerciseListTodayMode).todaySchedule,
        equals(today),
      );

      mt.verify(() => wired.today(const GetTodayScheduleParams(_userId)))
          .called(1);
    });

    test(
        'switchToAllMode enters Loading first, then AllMode(allExercises) '
        'on a Right', () async {
      final all = [_ex('x'), _ex('y')];
      final wired = _wire(todayList: const [], allList: all);
      addTearDown(wired.cubit.close);

      // Settle the cubit in todayMode first, otherwise the leading
      // `emit(loading)` inside `switchToAllMode` would be deduped against
      // the seed state and we could not observe the "Loading first" half.
      await wired.cubit.loadInitial(_userId);
      expect(wired.cubit.state, isA<ExerciseListTodayMode>());

      // While the use case future is in-flight the state is loading.
      final future = wired.cubit.switchToAllMode();
      expect(wired.cubit.state, isA<ExerciseListLoading>());

      await future;

      // After the use case resolves the cubit settles into allMode.
      expect(wired.cubit.state, isA<ExerciseListAllMode>());
      expect(
        (wired.cubit.state as ExerciseListAllMode).allExercises,
        equals(all),
      );
    });

    test(
        'loadInitial settles in Error when the today use case returns a '
        'Left — Validates Requirement 5.1', () async {
      final today = _MockGetTodayScheduleUseCase();
      final all = _MockGetAllExercisesUseCase();
      mt
          .when(() => today(const GetTodayScheduleParams(_userId)))
          .thenAnswer((_) async => const Left(
                Failure.cache(message: 'today-cache-error'),
              ));
      final cubit = ExerciseListCubit(today, all);
      addTearDown(cubit.close);

      expect(cubit.state, isA<ExerciseListLoading>());
      final future = cubit.loadInitial(_userId);
      expect(cubit.state, isA<ExerciseListLoading>());
      await future;

      expect(cubit.state, isA<ExerciseListError>());
      expect((cubit.state as ExerciseListError).message, 'today-cache-error');
    });

    test(
        'switchToAllMode settles in Error when the all use case returns a '
        'Left — Validates Requirement 5.3', () async {
      final today = _MockGetTodayScheduleUseCase();
      final all = _MockGetAllExercisesUseCase();
      mt
          .when(() => today(const GetTodayScheduleParams(_userId)))
          .thenAnswer((_) async => const Right(<ExerciseEntity>[]));
      mt.when(() => all(const NoParams())).thenAnswer(
            (_) async => const Left(
              Failure.unexpected(message: 'all-unexpected-error'),
            ),
          );
      final cubit = ExerciseListCubit(today, all);
      addTearDown(cubit.close);

      await cubit.loadInitial(_userId);
      expect(cubit.state, isA<ExerciseListTodayMode>());

      final future = cubit.switchToAllMode();
      expect(cubit.state, isA<ExerciseListLoading>());
      await future;

      expect(cubit.state, isA<ExerciseListError>());
      expect(
        (cubit.state as ExerciseListError).message,
        'all-unexpected-error',
      );
    });
  });
}
