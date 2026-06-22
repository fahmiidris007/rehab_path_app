// Property-based widget tests for the "Next: …" button enable/disable
// contract on [ExerciseDetailPage].
//
// This file covers task 14.4 of `.kiro/specs/app-flow-adjustments/tasks.md`:
//
//   * Property 16 (task 14.4): "Next" button is enabled whenever the next
//     exercise exists.
//     **Validates: Requirements 11.1, 11.2, 11.4, 11.6**
//
// Test strategy
// -------------
// The full page wiring (HomeCubit, AuthCubit, Hive, GoRouter) is an
// expensive harness for what is, in essence, a tiny pure decision:
//
//   button enabled  iff  nextExercise != null && !isLoading
//
// To drive that contract under property testing without standing up the
// full dependency graph, we lifted the button widget out of
// `exercise_detail_page.dart` as the public [NextExerciseButton] (its
// production behavior is authored by task 14.2). The widget receives the
// two inputs that drive the contract — `nextExercise` (here always non-null
// when rendered) and `isLoading` — plus the two localized labels resolved
// upstream by the page from `AppLocalizations`.
//
// `glados` exposes its property-running adapter as `Glados<...>.test(...)`
// which in turn calls `package:test`'s `test()` — that is incompatible
// with [WidgetTester], which requires `testWidgets`. We therefore use
// glados purely as a generator factory and drive iteration manually
// inside a single `testWidgets` block, calling `tester.pumpWidget` for
// every generated input. This pattern preserves coverage (>100 inputs)
// while keeping a real widget tree per case.
//
// For each generated tuple `(ExerciseEntity?, bool)` we pump a minimal
// wrapper that mirrors the production gate in
// `_ExerciseDetailViewState.build`:
//
//   if (nextExercise != null) NextExerciseButton(...)
//
// We then assert:
//
//   * `nextExercise == null`              → no [OutlinedButton] is rendered
//   * `nextExercise != null && !loading`  → button is enabled
//                                            (`onPressed != null`)
//                                            and shows `Next: <name>`
//   * `nextExercise != null && loading`   → button is disabled
//                                            (`onPressed == null`)
//                                            and shows `Loading…`
//
// Localized strings are looked up by their English ARB values
// (`exerciseNext` → "Next: {name}", `commonLoading` → "Loading…") because
// `MaterialApp.router(locale: const Locale('en'))` pins the test to English.
//
// Import note
// -----------
// `glados` re-exports `package:test/test.dart` which collides with
// `flutter_test`'s `setUpAll`/`group`/`test`/`expect`. We hide the
// duplicates from glados and keep the `flutter_test` versions.

// `glados` re-exports `dart:math` show Random for use inside generators
// — we use it directly to seed the manual property loop below.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glados/glados.dart'
    hide expect, group, test, setUpAll, setUp, tearDown, tearDownAll;
import 'package:go_router/go_router.dart';
import 'package:laman_lansia/features/exercise/presentation/pages/exercise_detail_page.dart';
import 'package:laman_lansia/l10n/app_localizations.dart';
import 'package:laman_lansia/shared/domain/entities/exercise_entity.dart';
import 'package:laman_lansia/shared/domain/enums/app_enums.dart';

// ── Fixtures ─────────────────────────────────────────────────────────────────

/// Builds an exercise whose `name == id` so the rendered `Next: <name>`
/// label (with `<name>` substituted) is trivially predictable from the input.
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

extension _NextButtonAnys on Any {
  /// Identifiable, short ids so failure diagnostics surface tractable
  /// counter-examples (e.g. `e_0`, `e_1`, …).
  Generator<ExerciseEntity> get exercise =>
      intInRange(0, 1024).map((n) => _ex('e_$n'));

  /// A nullable exercise — covers both "rendered" and "not rendered"
  /// branches of the page-level gate.
  Generator<ExerciseEntity?> get nullableExercise => exercise.nullable;
}

// ── Test harness ─────────────────────────────────────────────────────────────

/// Pumps a [NextExerciseButton] (or nothing, mirroring the page gate)
/// inside a [MaterialApp.router] with English [AppLocalizations]. A
/// fresh [GoRouter] is built per pump so route state from a previous
/// case never leaks into the next assertion.
Future<void> _pumpCase(
  WidgetTester tester, {
  required ExerciseEntity? nextExercise,
  required bool isLoading,
}) async {
  final router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) {
          if (nextExercise == null) {
            return const Scaffold(body: SizedBox.shrink());
          }
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Center(
              child: NextExerciseButton(
                nextExercise: nextExercise,
                isLoading: isLoading,
                loadingLabel: l10n.commonLoading,
                enabledLabel: l10n.exerciseNext(nextExercise.name),
              ),
            ),
          );
        },
      ),
      // Stub destination route so an enabled-button tap (if ever exercised)
      // would resolve, even though the property test only inspects
      // `onPressed != null` rather than tapping.
      GoRoute(
        path: '/exercise/:id',
        builder: (context, state) =>
            const Scaffold(body: SizedBox.shrink()),
      ),
    ],
  );

  await tester.pumpWidget(
    MaterialApp.router(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
  await tester.pump();
}

/// Asserts the contract for one input pair against the freshly-pumped
/// widget tree. Keeps reasons descriptive so any future regression
/// reports the exact `(nextExercise, isLoading)` that triggered it.
void _assertCase(
  WidgetTester tester, {
  required ExerciseEntity? nextExercise,
  required bool isLoading,
}) {
  final outlinedButtonFinder = find.byType(OutlinedButton);

  if (nextExercise == null) {
    // Branch 1 — page gate hides the widget entirely.
    expect(
      outlinedButtonFinder,
      findsNothing,
      reason: 'When nextExercise is null the button must not render at '
          'all (input: nextExercise=null, isLoading=$isLoading)',
    );
    return;
  }

  // Branch 2 + 3 — button is rendered.
  expect(
    outlinedButtonFinder,
    findsOneWidget,
    reason: 'When nextExercise is non-null the button must render exactly '
        'once (input: nextExercise=${nextExercise.id}, '
        'isLoading=$isLoading)',
  );

  final button = tester.widget<OutlinedButton>(outlinedButtonFinder);

  if (isLoading) {
    // Branch 3 — disabled with loading label (Requirement 11.4).
    expect(
      button.onPressed,
      isNull,
      reason: 'Loading state must disable the button (input: '
          'nextExercise=${nextExercise.id}, isLoading=true)',
    );
    expect(
      find.text('Loading…'),
      findsOneWidget,
      reason: 'Loading state must show the localized commonLoading '
          'label "Loading…" (input: nextExercise=${nextExercise.id})',
    );
  } else {
    // Branch 2 — enabled with localized "Next: <name>" label
    // (Requirements 11.1, 11.2, 11.6).
    expect(
      button.onPressed,
      isNotNull,
      reason: 'Non-loading state must enable the button (input: '
          'nextExercise=${nextExercise.id}, isLoading=false)',
    );
    expect(
      find.text('Next: ${nextExercise.name}'),
      findsOneWidget,
      reason: 'Non-loading state must show the localized exerciseNext '
          'label "Next: ${nextExercise.name}"',
    );
  }
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  group(
      'Property 16: "Next" button is enabled whenever the next exercise '
      'exists — Validates Requirements 11.1, 11.2, 11.4, 11.6', () {
    // We drive >= 100 generator-produced cases manually inside a single
    // `testWidgets`. See the file header for why we cannot use
    // `Glados2.test(...)` directly here.
    testWidgets(
      'rendered widget matches the contract for arbitrary '
      '(nextExercise, isLoading)',
      (tester) async {
        // Deterministic seed so failures reproduce locally and on CI.
        final random = Random(0x16);
        final exerciseGen = any.nullableExercise;
        const totalCases = 128;

        for (var i = 0; i < totalCases; i++) {
          // Grow `size` linearly the way [ExploreConfig] would, so the
          // generator visits a healthy spread of values.
          final size = 10 + i;
          final nextExercise = exerciseGen(random, size).value;
          final isLoading = any.bool(random, size).value;

          await _pumpCase(
            tester,
            nextExercise: nextExercise,
            isLoading: isLoading,
          );
          _assertCase(
            tester,
            nextExercise: nextExercise,
            isLoading: isLoading,
          );
        }
      },
    );

    // Pinned example cases — one per branch — so the contract is anchored
    // even if the generator distribution shifts in a future glados upgrade.
    testWidgets(
      'example: nextExercise == null does not render the button',
      (tester) async {
        await _pumpCase(tester, nextExercise: null, isLoading: false);
        expect(find.byType(OutlinedButton), findsNothing);

        await _pumpCase(tester, nextExercise: null, isLoading: true);
        expect(find.byType(OutlinedButton), findsNothing);
      },
    );

    testWidgets(
      'example: nextExercise != null && !isLoading renders enabled '
      '"Next: <name>"',
      (tester) async {
        final next = _ex('balance-1');
        await _pumpCase(tester, nextExercise: next, isLoading: false);

        final finder = find.byType(OutlinedButton);
        expect(finder, findsOneWidget);
        expect(
          tester.widget<OutlinedButton>(finder).onPressed,
          isNotNull,
        );
        expect(find.text('Next: balance-1'), findsOneWidget);
      },
    );

    testWidgets(
      'example: nextExercise != null && isLoading renders disabled '
      '"Loading…"',
      (tester) async {
        final next = _ex('balance-2');
        await _pumpCase(tester, nextExercise: next, isLoading: true);

        final finder = find.byType(OutlinedButton);
        expect(finder, findsOneWidget);
        expect(
          tester.widget<OutlinedButton>(finder).onPressed,
          isNull,
        );
        expect(find.text('Loading…'), findsOneWidget);
        expect(find.text('Next: balance-2'), findsNothing);
      },
    );
  });
}
