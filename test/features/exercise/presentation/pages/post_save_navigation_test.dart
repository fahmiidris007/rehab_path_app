// Property-based and example tests for [PostSaveNavigation.decide].
//
// This file covers task 13.7 of `.kiro/specs/app-flow-adjustments/tasks.md`:
//
//   * Property 15 (task 13.7): Post-save navigation always advances to the
//     next incomplete exercise or home.
//     **Validates: Requirement 10.5**
//
// Test strategy
// -------------
// `PostSaveNavigation.decide` is a pure, dependency-free function whose
// inputs are:
//
//   * `nextExercise: ExerciseEntity?` — null when no next incomplete
//     exercise exists, otherwise a real `ExerciseEntity`.
//   * `allTodayDone: bool` — whether every exercise in today's schedule has
//     been completed.
//
// Property 15 expresses the routing contract:
//
//   * If `nextExercise != null && !allTodayDone` → result is
//     `ExerciseDetailRoute(id: nextExercise.id)`.
//   * Otherwise → result is `HomeRoute(allTodayDone: allTodayDone)`.
//
// The result is also exhaustive: every input pair settles in either an
// `ExerciseDetailRoute` or a `HomeRoute` — no other shape, no exception.
//
// We use `glados` for the property and pin two example cases (one per
// branch) for readability and to anchor the contract against shrinking.
//
// Import note: `glados` re-exports `package:test_core/scaffolding.dart`
// which collides with `flutter_test`'s `setUpAll`/`group`/`test`/`expect`.
// We hide the duplicates from glados and keep the `flutter_test` versions.

import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart'
    hide expect, group, test, setUpAll, setUp, tearDown, tearDownAll;
import 'package:teman_lansia/features/exercise/presentation/pages/post_save_navigation.dart';
import 'package:teman_lansia/shared/domain/entities/exercise_entity.dart';
import 'package:teman_lansia/shared/domain/enums/app_enums.dart';

// ── Fixtures ─────────────────────────────────────────────────────────────────

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

// ── Glados generators ────────────────────────────────────────────────────────

extension _PostSaveAnys on Any {
  /// A non-null exercise with a short, identifiable id so failure shrinking
  /// surfaces tractable counter-examples.
  Generator<ExerciseEntity> get exercise =>
      intInRange(0, 1024).map((n) => _ex('e_$n'));

  /// A nullable exercise — covers both branches of the null-check inside
  /// `PostSaveNavigation.decide`. Nulls are explicitly mixed in via
  /// glados's `.nullable` extension so the shrinker can collapse to either
  /// side.
  Generator<ExerciseEntity?> get nullableExercise => exercise.nullable;
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  group(
      'Property 15: Post-save navigation always advances to next incomplete '
      'or home — Validates Requirement 10.5', () {
    Glados2<ExerciseEntity?, bool>(
      any.nullableExercise,
      any.bool,
    ).test(
      'decide(nextExercise, allTodayDone) matches the routing contract '
      'for every input pair',
      (nextExercise, allTodayDone) {
        final route = PostSaveNavigation.decide(
          nextExercise: nextExercise,
          allTodayDone: allTodayDone,
        );

        // Exhaustiveness — the result is always one of the two concrete
        // shapes; never null, never a different runtime type.
        expect(
          route,
          anyOf(isA<ExerciseDetailRoute>(), isA<HomeRoute>()),
          reason: 'decide must return either an ExerciseDetailRoute or a '
              'HomeRoute for every input',
        );

        if (nextExercise != null && !allTodayDone) {
          // Next-incomplete branch: route must carry the next exercise's id.
          expect(
            route,
            isA<ExerciseDetailRoute>(),
            reason: 'When a next exercise exists and the schedule is not '
                'fully done, decide must route to exercise detail',
          );
          expect(
            (route as ExerciseDetailRoute).id,
            equals(nextExercise.id),
            reason: 'ExerciseDetailRoute must reference nextExercise.id',
          );
        } else {
          // Home branch: route must be HomeRoute and carry the allTodayDone
          // flag verbatim so the caller can decide whether to surface the
          // "Semua latihan hari ini selesai" snackbar.
          expect(
            route,
            isA<HomeRoute>(),
            reason: 'When there is no next exercise OR the schedule is '
                'already fully done, decide must route to home',
          );
          expect(
            (route as HomeRoute).allTodayDone,
            equals(allTodayDone),
            reason: 'HomeRoute.allTodayDone must equal the input',
          );
        }
      },
    );
  });

  group('PostSaveNavigation.decide — example contract', () {
    test(
        'next exercise present and not all done routes to exercise detail '
        'with the matching id', () {
      final next = _ex('next-1');

      final route = PostSaveNavigation.decide(
        nextExercise: next,
        allTodayDone: false,
      );

      expect(route, isA<ExerciseDetailRoute>());
      expect((route as ExerciseDetailRoute).id, 'next-1');
      expect(route, equals(const ExerciseDetailRoute('next-1')));
    });

    test('all today done routes to home with allTodayDone: true even if a '
        'next exercise is somehow still present', () {
      // The "all done" flag wins over a stale `nextExercise` reference —
      // this guards against the home cubit briefly returning both before
      // its next refresh.
      final route = PostSaveNavigation.decide(
        nextExercise: _ex('stale'),
        allTodayDone: true,
      );

      expect(route, isA<HomeRoute>());
      expect((route as HomeRoute).allTodayDone, isTrue);
      expect(route, equals(const HomeRoute(allTodayDone: true)));
    });

    test('no next exercise and not all done routes to home with '
        'allTodayDone: false (edge case)', () {
      final route = PostSaveNavigation.decide(
        nextExercise: null,
        allTodayDone: false,
      );

      expect(route, isA<HomeRoute>());
      expect((route as HomeRoute).allTodayDone, isFalse);
      expect(route, equals(const HomeRoute(allTodayDone: false)));
    });

    test('no next exercise and all done routes to home with '
        'allTodayDone: true', () {
      final route = PostSaveNavigation.decide(
        nextExercise: null,
        allTodayDone: true,
      );

      expect(route, isA<HomeRoute>());
      expect((route as HomeRoute).allTodayDone, isTrue);
    });
  });
}
