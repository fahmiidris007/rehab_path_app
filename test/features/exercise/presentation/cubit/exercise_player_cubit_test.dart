// Property-based and example tests for [ExercisePlayerCubit].
//
// This file covers tasks 13.6, 13.8, 13.9 of
// `.kiro/specs/app-flow-adjustments/tasks.md`:
//
//   * Property 14 (task 13.6): Player auto-saves with defaults and never
//     emits PlayerSelfReport.
//     **Validates: Requirements 10.1, 10.2, 10.4**
//
//   * Property 17 (task 13.8): Saved session IDs are globally unique and
//     follow the `session_<userId>_<microseconds>` format.
//     **Validates: Requirements 12.3**
//
//   * Property 18 (task 13.9): Timer never fires after leaving
//     PlayerPlaying. Random sequences of pause/resume/skip/close/
//     cancelSession ops are applied; after each op, time is advanced by
//     several seconds and we assert the cubit's state never changes
//     unless that op put the cubit back into PlayerPlaying.
//     **Validates: Requirements 12.5**
//
// Test strategy
// -------------
// `ExercisePlayerCubit` collaborates with two use cases:
//   * [SaveExerciseSessionUseCase]    — invoked by skip() and the
//     timer-zero auto-save path.
//   * [DeletePartialSessionUseCase]   — invoked by cancelSession().
//
// Both are faked with `mocktail` so the cubit is exercised end-to-end
// without touching Hive, the repository, or DI. Each property iteration
// constructs a fresh cubit + fresh mocks so state transitions are
// hermetic.
//
// Property 18 uses `package:fake_async` to drive `Timer.periodic`
// deterministically — without it, exhaustive coverage of multi-step
// sequences would require seconds of real time per iteration.
//
// Import note: glados re-exports `package:test_core/scaffolding.dart`,
// which collides with `flutter_test`'s `setUpAll`/`group`/`test`/
// `expect`. We keep the `flutter_test` versions and hide the duplicates
// from glados. Mocktail's `any` collides with glados's `any` extension
// receiver, so mocktail is imported under the `mt` prefix.

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart'
    hide expect, group, test, setUpAll, setUp, tearDown, tearDownAll;
import 'package:mocktail/mocktail.dart' as mt;
import 'package:laman_lansia/core/errors/failures.dart';
import 'package:laman_lansia/features/exercise/domain/usecases/delete_partial_session_use_case.dart';
import 'package:laman_lansia/features/exercise/domain/usecases/save_exercise_session_use_case.dart';
import 'package:laman_lansia/features/exercise/presentation/cubit/exercise_player_cubit.dart';
import 'package:laman_lansia/features/exercise/presentation/cubit/player_state.dart';
import 'package:laman_lansia/shared/domain/entities/exercise_entity.dart';
import 'package:laman_lansia/shared/domain/entities/exercise_session_entity.dart';
import 'package:laman_lansia/shared/domain/enums/app_enums.dart';

// ── Mocks ────────────────────────────────────────────────────────────────────

class _MockSaveSessionUseCase extends mt.Mock
    implements SaveExerciseSessionUseCase {}

class _MockDeletePartialSessionUseCase extends mt.Mock
    implements DeletePartialSessionUseCase {}

// ── Fixtures ─────────────────────────────────────────────────────────────────

ExerciseEntity _ex(String id, {int durationSeconds = 30}) => ExerciseEntity(
      id: id,
      name: id,
      category: ExerciseCategory.balanceTraining,
      description: 'desc-$id',
      steps: const ['step'],
      durationSeconds: durationSeconds,
      sets: 1,
      reps: 1,
      difficulty: 1,
      safetyTips: const [],
      imagePath: '',
      recommendedLevel: ProgramLevel.beginner,
    );

ExerciseSessionEntity _dummySession() => ExerciseSessionEntity(
      id: 'fallback',
      exerciseId: 'fallback',
      userId: 'fallback',
      completedAt: DateTime.fromMillisecondsSinceEpoch(0),
      bodyCondition: BodyCondition.standing,
      supportUsed: SupportUsed.noSupport,
    );

/// Wires fresh use case mocks and an [ExercisePlayerCubit]. The save
/// stub returns `Right(unit)` and appends every saved session to
/// [captured] so the property tests can inspect IDs and default values.
({
  ExercisePlayerCubit cubit,
  _MockSaveSessionUseCase save,
  _MockDeletePartialSessionUseCase deletePartial,
  List<ExerciseSessionEntity> captured,
}) _wire() {
  final save = _MockSaveSessionUseCase();
  final deletePartial = _MockDeletePartialSessionUseCase();
  final captured = <ExerciseSessionEntity>[];

  mt.when(() => save.call(mt.any())).thenAnswer((invocation) async {
    final params =
        invocation.positionalArguments.first as SaveExerciseSessionParams;
    captured.add(params.session);
    return const Right<Failure, Unit>(unit);
  });
  mt.when(() => deletePartial.call(mt.any())).thenAnswer(
    (_) async => const Right<Failure, Unit>(unit),
  );

  return (
    cubit: ExercisePlayerCubit(save, deletePartial),
    save: save,
    deletePartial: deletePartial,
    captured: captured,
  );
}

// ── Operation model for Property 18 ──────────────────────────────────────────

/// One step in the property-test sequence. `close` ends the cubit; once
/// closed, no further operations are applied.
enum _Op { pause, resume, skip, cancelSession, close }

_Op _opFromIndex(int i) => _Op.values[i % _Op.values.length];

// ── Glados generators ────────────────────────────────────────────────────────

extension _PlayerAnys on Any {
  /// Short user ids so failure shrinking surfaces small counter-examples.
  Generator<String> get userId =>
      intInRange(0, 1024).map((n) => 'user_$n');

  /// Short exercise ids.
  Generator<String> get exerciseId =>
      intInRange(0, 1024).map((n) => 'ex_$n');

  /// Duration in [1, 5] seconds — small enough to drive auto-save
  /// scenarios quickly while still exercising multiple timer ticks.
  /// Named `durationSeconds` to avoid colliding with glados's built-in
  /// `Generator<Duration> get duration` extension on [Any].
  Generator<int> get durationSeconds => intInRange(1, 6);

  /// Op-index list (length 1..6) used to build operation sequences for
  /// Property 18. Indexing into [_Op.values] keeps the alphabet small so
  /// shrinking can find minimal failing sequences.
  Generator<List<int>> get opIndices =>
      listWithLengthInRange(1, 7, intInRange(0, _Op.values.length));
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() {
    // Mocktail requires fallback values when `mt.any()` matchers are
    // used with non-nullable parameter types.
    mt.registerFallbackValue(SaveExerciseSessionParams(_dummySession()));
    mt.registerFallbackValue(const DeletePartialSessionParams(''));
  });

  group(
      'Property 14: Player auto-saves with defaults and never emits '
      'PlayerSelfReport — Validates Requirements 10.1, 10.2, 10.4', () {
    Glados3<String, String, int>(
      any.userId,
      any.exerciseId,
      any.durationSeconds,
    ).test(
      'startExercise → skip auto-saves with default body/support and '
      'never emits PlayerSelfReport',
      (userId, exerciseId, durationSeconds) async {
        final wired = _wire();
        addTearDown(wired.cubit.close);

        final emitted = <PlayerState>[];
        final sub = wired.cubit.stream.listen(emitted.add);
        addTearDown(sub.cancel);

        final exercise = _ex(exerciseId, durationSeconds: durationSeconds);
        wired.cubit.startExercise(exercise, userId: userId);

        // Yield so the synchronous `emit(playing)` is delivered to the
        // stream subscription before we drive `skip()`.
        await Future<void>.delayed(Duration.zero);

        await wired.cubit.skip();

        // Yield once more so the trailing `emit(saved)` reaches the
        // subscription buffer.
        await Future<void>.delayed(Duration.zero);

        // R10.1 + R10.4: PlayerSelfReport must never appear in the
        // emission stream of the new auto-save flow.
        expect(
          emitted.whereType<PlayerSelfReport>(),
          isEmpty,
          reason: 'Auto-save flow must not emit PlayerSelfReport',
        );

        // R10.2: the playing → saving → saved transitions must occur.
        expect(
          emitted.whereType<PlayerPlaying>(),
          isNotEmpty,
          reason: 'Auto-save flow must emit PlayerPlaying first',
        );
        expect(
          emitted.whereType<PlayerSaving>(),
          isNotEmpty,
          reason: 'Auto-save flow must emit PlayerSaving',
        );
        expect(
          emitted.whereType<PlayerSaved>(),
          isNotEmpty,
          reason: 'Auto-save flow must emit PlayerSaved',
        );

        // R10.2: the saved session must use the documented defaults
        // (BodyCondition.standing, SupportUsed.noSupport) and reflect
        // the userId/exerciseId supplied to startExercise.
        expect(wired.captured, hasLength(1));
        final session = wired.captured.single;
        expect(session.userId, equals(userId));
        expect(session.exerciseId, equals(exerciseId));
        expect(session.bodyCondition, equals(BodyCondition.standing));
        expect(session.supportUsed, equals(SupportUsed.noSupport));
      },
    );
  });

  group(
      'Property 17: Saved session IDs are globally unique and follow the '
      'session_<userId>_<microseconds> format — Validates Requirement '
      '12.3', () {
    Glados2<String, String>(any.userId, any.userId).test(
      'two consecutive start+skip cycles produce two distinct session '
      'ids of the documented shape',
      (userIdA, userIdB) async {
        final wired = _wire();
        addTearDown(wired.cubit.close);

        final exerciseA = _ex('ex_a');
        final exerciseB = _ex('ex_b');

        wired.cubit.startExercise(exerciseA, userId: userIdA);
        await wired.cubit.skip();

        // Yield so DateTime.now() advances at least one microsecond
        // between the two start-id generations. Without this, very fast
        // executions could collide on the same microsecondsSinceEpoch.
        await Future<void>.delayed(const Duration(microseconds: 1));

        wired.cubit.startExercise(exerciseB, userId: userIdB);
        await wired.cubit.skip();

        // Both saves must have landed exactly once.
        expect(wired.captured, hasLength(2));

        final ids = wired.captured.map((s) => s.id).toList();

        // R12.3: globally unique session ids.
        expect(
          ids.toSet(),
          hasLength(ids.length),
          reason:
              'Saved session ids must be globally unique even across '
              'consecutive saves',
        );

        // Documented format: `session_<userId>_<microseconds>`.
        final pattern = RegExp(r'^session_(.+)_(\d+)$');
        for (var i = 0; i < ids.length; i++) {
          final id = ids[i];
          final expectedUserId = i == 0 ? userIdA : userIdB;
          final match = pattern.firstMatch(id);
          expect(
            match,
            isNotNull,
            reason: 'Session id "$id" must match '
                'session_<userId>_<microseconds>',
          );
          expect(
            match!.group(1),
            equals(expectedUserId),
            reason: 'Session id userId segment must equal the userId '
                'passed to startExercise',
          );
          // The microseconds segment must be a positive integer.
          expect(int.parse(match.group(2)!), greaterThan(0));
        }
      },
    );
  });

  group(
      'Property 18: Timer never fires after leaving PlayerPlaying — '
      'Validates Requirement 12.5', () {
    Glados<List<int>>(any.opIndices).test(
      'random pause/resume/skip/cancelSession/close sequences leave the '
      'cubit\'s state stable whenever it is not in PlayerPlaying, even '
      'after multiple seconds elapse',
      (opIndices) {
        // Drive the cubit deterministically through fake time. We use a
        // long-duration exercise (1000s) so the natural timer-zero
        // auto-save never fires — only operations should produce
        // transitions.
        fakeAsync((async) {
          final wired = _wire();

          final exercise = _ex('ex_long', durationSeconds: 1000);
          wired.cubit.startExercise(exercise, userId: 'u');
          async.flushMicrotasks();

          for (final idx in opIndices) {
            if (wired.cubit.isClosed) {
              break;
            }
            final op = _opFromIndex(idx);

            switch (op) {
              case _Op.pause:
                wired.cubit.pause();
              case _Op.resume:
                wired.cubit.resume();
              case _Op.skip:
                // Fire-and-forget: `skip()` is async but emits
                // synchronously; we let microtasks flush below.
                unawaited(wired.cubit.skip());
              case _Op.cancelSession:
                unawaited(wired.cubit.cancelSession());
              case _Op.close:
                unawaited(wired.cubit.close());
            }
            async.flushMicrotasks();

            if (wired.cubit.isClosed) {
              // After close(), the cubit can no longer emit; further
              // ops would throw. The property is trivially preserved.
              break;
            }

            final stateBeforeElapse = wired.cubit.state;
            final wasPlaying = stateBeforeElapse is PlayerPlaying;

            // Advance fake time by 5 seconds — enough for 5 ticks of
            // the cubit's `Timer.periodic(Duration(seconds: 1))`.
            async.elapse(const Duration(seconds: 5));
            async.flushMicrotasks();

            if (!wasPlaying) {
              expect(
                wired.cubit.state,
                equals(stateBeforeElapse),
                reason: 'Timer fired after leaving PlayerPlaying: state '
                    'changed from $stateBeforeElapse to '
                    '${wired.cubit.state} after applying op '
                    '${op.name}',
              );
            }
          }

          if (!wired.cubit.isClosed) {
            wired.cubit.close();
          }
          async.flushMicrotasks();
        });
      },
    );
  });
}
