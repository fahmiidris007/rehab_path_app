// Widget tests for [ProgressPage] — task 12.5 of
// `.kiro/specs/app-flow-adjustments/tasks.md`.
//
// Asserts that the Progress page renders [QuickStatsRow] exactly once,
// reflecting the values supplied by [ProgressViewData].
//
// **Validates: Requirements 8.2, 8.5, 8.6.**
//
// Test strategy
// -------------
// `ProgressPage` resolves its [ProgressCubit] from `getIt`. We register a
// `bloc_test` [MockCubit] for [ProgressCubit] against the DI container,
// stub `loadProgress` so the post-frame callback is harmless, and seed the
// cubit's initial state with [ProgressLoaded] containing the canonical
// fixture values from the task description (`totalMinutes: 100,
// totalSessions: 10, streakDays: 3`).
//
// `AuthCubit` is provided through a `BlocProvider<AuthCubit>.value` above
// the page so `_load` reads `AuthAuthenticated` and computes a non-null
// user id.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teman_lansia/di/injection.dart';
import 'package:teman_lansia/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:teman_lansia/features/auth/presentation/cubit/auth_state.dart';
import 'package:teman_lansia/features/progress/presentation/cubit/progress_cubit.dart';
import 'package:teman_lansia/features/progress/presentation/cubit/progress_state.dart';
import 'package:teman_lansia/features/progress/presentation/pages/progress_page.dart';
import 'package:teman_lansia/features/progress/presentation/widgets/quick_stats_row.dart';
import 'package:teman_lansia/l10n/app_localizations.dart';
import 'package:teman_lansia/shared/domain/entities/user_entity.dart';
import 'package:teman_lansia/shared/domain/enums/app_enums.dart';

class _MockProgressCubit extends MockCubit<ProgressState>
    implements ProgressCubit {}

class _MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

UserEntity _userFixture() => const UserEntity(
      id: 'u1',
      name: 'Test User',
      phoneNumber: '+6281234567890',
      age: 70,
      gender: 'female',
      programLevel: ProgramLevel.beginner,
      healthConditions: <String>[],
      emergencyContacts: [],
    );

ProgressViewData _progressDataFixture() => const ProgressViewData(
      weeklyAdherenceRate: 0.0,
      monthlyAdherenceRate: 0.0,
      balanceScores: [],
      fallEventsThisMonth: [],
      badges: [],
      recentSessions: [],
      workedMuscleGroups: <String>{},
      totalMinutes: 100,
      totalSessions: 10,
      streakDays: 3,
    );

Widget _harness({
  required ProgressCubit progressCubit,
  required AuthCubit authCubit,
}) {
  return BlocProvider<AuthCubit>.value(
    value: authCubit,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const ProgressPage(),
    ),
  );
}

void main() {
  late _MockProgressCubit progressCubit;
  late _MockAuthCubit authCubit;

  setUp(() {
    progressCubit = _MockProgressCubit();
    authCubit = _MockAuthCubit();

    // Stub `loadProgress` so the post-frame callback in the page's
    // `initState` is a no-op against the mock.
    when(() => progressCubit.loadProgress(any())).thenAnswer((_) async {});

    whenListen(
      progressCubit,
      const Stream<ProgressState>.empty(),
      initialState: ProgressState.loaded(_progressDataFixture()),
    );
    whenListen(
      authCubit,
      const Stream<AuthState>.empty(),
      initialState: AuthState.authenticated(_userFixture()),
    );

    if (getIt.isRegistered<ProgressCubit>()) {
      getIt
        ..allowReassignment = true
        ..unregister<ProgressCubit>();
    }
    getIt.registerFactory<ProgressCubit>(() => progressCubit);
  });

  tearDown(() async {
    if (getIt.isRegistered<ProgressCubit>()) {
      await getIt.unregister<ProgressCubit>();
    }
  });

  testWidgets(
    'QuickStatsRow is rendered exactly once on the Progress page '
    '(Validates: Requirements 8.2, 8.5, 8.6)',
    (tester) async {
      await tester.pumpWidget(_harness(
        progressCubit: progressCubit,
        authCubit: authCubit,
      ));
      // First pump installs MaterialApp; second flushes the post-frame
      // `_load` callback so the page is in its final loaded state.
      await tester.pump();
      await tester.pump();

      expect(
        find.byType(ProgressPage),
        findsOneWidget,
        reason: 'ProgressPage must be present in the widget tree.',
      );

      expect(
        find.byType(QuickStatsRow),
        findsOneWidget,
        reason: 'QuickStatsRow must be rendered exactly once on Progress '
            '(R8.2, R8.5).',
      );

      // Confirm the row was wired to the cubit's data, not a default
      // zero-state, by sampling each of the three values from the fixture.
      // Render-time access goes through `AppLocalizations`, but the values
      // themselves are plain text and locale-independent.
      final row = tester.widget<QuickStatsRow>(find.byType(QuickStatsRow));
      expect(row.totalMinutes, 100);
      expect(row.totalSessions, 10);
      expect(row.streakDays, 3);
    },
  );
}
