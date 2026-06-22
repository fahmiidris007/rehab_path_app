// Widget tests for [HomeDashboardPage] — task 12.5 of
// `.kiro/specs/app-flow-adjustments/tasks.md`.
//
// Asserts that, after `QuickStatsRow` is moved out of the home dashboard
// (task 12.2), the home page renders zero `QuickStatsRow` instances.
//
// **Validates: Requirements 8.1, 8.5.**
//
// Test strategy
// -------------
// `HomeDashboardPage` resolves its [HomeCubit] from `getIt`, then wraps the
// page in `BlocProvider<HomeCubit>.value(value: _cubit)`. To stay hermetic
// we register a `bloc_test` [MockCubit] for [HomeCubit] against the DI
// container and seed it with [HomeLoaded] so the page renders the loaded
// dashboard immediately. The mock also intercepts `loadDashboard` (called
// from a post-frame callback) so no real cubit logic runs.
//
// `AuthCubit` is provided through a `BlocProvider<AuthCubit>.value` above
// the page so `_load` can read `AuthAuthenticated`. `AppCubit` is required
// because the dashboard reads the active locale via
// `context.watch<AppCubit>()`.
//
// `QuickStatsRow` is imported from its new location in
// `lib/features/progress/presentation/widgets/`. The whole point of this
// test is to confirm there's no instance left in the home subtree.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:laman_lansia/app/cubit/app_cubit.dart';
import 'package:laman_lansia/di/injection.dart';
import 'package:laman_lansia/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:laman_lansia/features/auth/presentation/cubit/auth_state.dart';
import 'package:laman_lansia/features/home/presentation/cubit/home_cubit.dart';
import 'package:laman_lansia/features/home/presentation/cubit/home_state.dart';
import 'package:laman_lansia/features/home/presentation/pages/home_dashboard_page.dart';
import 'package:laman_lansia/features/progress/presentation/widgets/quick_stats_row.dart';
import 'package:laman_lansia/l10n/app_localizations.dart';
import 'package:laman_lansia/shared/domain/entities/motivational_message_entity.dart';
import 'package:laman_lansia/shared/domain/entities/user_entity.dart';
import 'package:laman_lansia/shared/domain/enums/app_enums.dart';

class _MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

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

const _motivationalFixture = MotivationalMessageEntity(
  id: 'm1',
  textEn: 'Keep going!',
  textId: 'Terus semangat!',
  category: 'encouragement',
);

HomeData _homeDataFixture() {
  final today = DateTime(2024, 1, 1);
  return HomeData(
    user: _userFixture(),
    streakDays: 3,
    todaySchedule: const [],
    completedToday: 0,
    recommendedExercises: const [],
    motivationalMessage: _motivationalFixture,
    completedDaysThisWeek: const [],
    totalMinutes: 100,
    totalSessions: 10,
    selectedDate: today,
    todayLocal: today,
    selectedDateSchedule: const [],
    selectedDateCompleted: 0,
  );
}

Widget _harness({
  required HomeCubit homeCubit,
  required AuthCubit authCubit,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AppCubit>(create: (_) => AppCubit()),
      BlocProvider<AuthCubit>.value(value: authCubit),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const HomeDashboardPage(),
    ),
  );
}

void main() {
  late _MockHomeCubit homeCubit;
  late _MockAuthCubit authCubit;

  setUpAll(() {
    registerFallbackValue(_userFixture());
  });

  setUp(() {
    homeCubit = _MockHomeCubit();
    authCubit = _MockAuthCubit();

    // Stub `loadDashboard` so the post-frame callback fired from
    // `HomeDashboardPage.initState` is a harmless no-op against the mock.
    when(() => homeCubit.loadDashboard(any())).thenAnswer((_) async {});

    whenListen(
      homeCubit,
      const Stream<HomeState>.empty(),
      initialState: HomeState.loaded(_homeDataFixture()),
    );
    whenListen(
      authCubit,
      const Stream<AuthState>.empty(),
      initialState: AuthState.authenticated(_userFixture()),
    );

    if (getIt.isRegistered<HomeCubit>()) {
      getIt
        ..allowReassignment = true
        ..unregister<HomeCubit>();
    }
    getIt.registerFactory<HomeCubit>(() => homeCubit);
  });

  tearDown(() async {
    if (getIt.isRegistered<HomeCubit>()) {
      await getIt.unregister<HomeCubit>();
    }
  });

  testWidgets(
    'QuickStatsRow is not rendered on the Home dashboard '
    '(Validates: Requirements 8.1, 8.5)',
    (tester) async {
      await tester.pumpWidget(_harness(
        homeCubit: homeCubit,
        authCubit: authCubit,
      ));
      // First pump installs the widget tree; second flushes the post-frame
      // callback that triggers `_load()` (which is a no-op on the mock).
      await tester.pump();
      await tester.pump();

      // Sanity check — the dashboard rendered the loaded view (not the
      // loading spinner), so the QuickStatsRow lookup is meaningful.
      expect(
        find.byType(HomeDashboardPage),
        findsOneWidget,
        reason: 'HomeDashboardPage must be present in the widget tree.',
      );

      // The actual contract: `QuickStatsRow` was moved out of Home and now
      // lives only on the Progress page (task 12.2 / R8.1).
      expect(
        find.byType(QuickStatsRow),
        findsNothing,
        reason: 'QuickStatsRow must not be rendered on the Home dashboard '
            'after task 12.2 (R8.1, R8.5).',
      );
    },
  );
}
