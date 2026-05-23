// Widget tests for [ExerciseListPage] navigator-stack invariance.
//
// This file covers the widget-level half of task 9.4 of
// `.kiro/specs/app-flow-adjustments/tasks.md`:
//
//   * Property 8 (task 9.4): Exercise list mode contract — switching between
//     today and all modes MUST NOT push or pop navigator routes.
//     **Validates: Requirements 5.1, 5.3, 5.6**
//
// Test strategy
// -------------
// `ExerciseListPage` builds its own [BlocProvider<ExerciseListCubit>] from
// the DI container with `getIt<ExerciseListCubit>()..loadInitial(userId)`,
// and reads the active user id from `AuthCubit.state`. To stay hermetic:
//
//   * We register a real [ExerciseListCubit] (factory) backed by mocked
//     use cases against [getIt] with `allowReassignment = true`. This is
//     the path the design document suggests when a test wrapper would be
//     too invasive (see task 9.4 description in tasks.md).
//
//   * `AuthCubit` is provided as a mocked instance through [BlocProvider]
//     so the page can read `AuthAuthenticated(user)` and resolve the user
//     id without booting the real cubit graph.
//
//   * A [NavigatorObserver] tracks `didPush` / `didPop` / `didReplace` so
//     the test can assert that the route stack depth is unchanged across
//     mode switches.
//
// All user-facing label lookups use the English ARB output via
// `AppLocalizations`, which is wired through the test's `MaterialApp`
// configuration so the rendered button labels match what the page
// produces in production.

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rehab_path_app/core/errors/failures.dart';
import 'package:rehab_path_app/core/usecases/use_case.dart';
import 'package:rehab_path_app/di/injection.dart';
import 'package:rehab_path_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:rehab_path_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:rehab_path_app/features/exercise/domain/usecases/get_all_exercises_use_case.dart';
import 'package:rehab_path_app/features/exercise/domain/usecases/get_today_schedule_use_case.dart';
import 'package:rehab_path_app/features/exercise/presentation/cubit/exercise_list_cubit.dart';
import 'package:rehab_path_app/features/exercise/presentation/pages/exercise_list_page.dart';
import 'package:rehab_path_app/l10n/app_localizations.dart';
import 'package:rehab_path_app/shared/domain/entities/exercise_entity.dart';
import 'package:rehab_path_app/shared/domain/entities/user_entity.dart';
import 'package:rehab_path_app/shared/domain/enums/app_enums.dart';

// ── Mocks ────────────────────────────────────────────────────────────────────

class _MockGetTodayScheduleUseCase extends Mock
    implements GetTodayScheduleUseCase {}

class _MockGetAllExercisesUseCase extends Mock
    implements GetAllExercisesUseCase {}

class _MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

// ── Fixtures ─────────────────────────────────────────────────────────────────

const _userId = 'user-1';

UserEntity _buildUser() => const UserEntity(
      id: _userId,
      name: 'Tester',
      phoneNumber: '+6281234567890',
      age: 65,
      gender: 'female',
      programLevel: ProgramLevel.beginner,
      healthConditions: [],
      emergencyContacts: [],
    );

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

// ── Navigator-depth observer ─────────────────────────────────────────────────

/// Tracks the running navigator depth so the test can assert that mode
/// switches do not push or pop routes (Requirement 5.6). Increments on
/// `didPush`, decrements on `didPop`. `didReplace` and `didRemove` are
/// observed without changing the count, but each event is recorded so the
/// test can fail with a precise reason if any of them fire.
class _DepthObserver extends NavigatorObserver {
  int depth = 0;
  final List<String> events = <String>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    depth++;
    events.add('push:${route.settings.name ?? route.runtimeType}');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    depth--;
    events.add('pop:${route.settings.name ?? route.runtimeType}');
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    events.add('replace');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    depth--;
    events.add('remove:${route.settings.name ?? route.runtimeType}');
    super.didRemove(route, previousRoute);
  }
}

// ── Test harness ─────────────────────────────────────────────────────────────

Widget _harness({
  required AuthCubit authCubit,
  required NavigatorObserver observer,
}) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    navigatorObservers: [observer],
    home: BlocProvider<AuthCubit>.value(
      value: authCubit,
      child: const ExerciseListPage(),
    ),
  );
}

void main() {
  late _MockGetTodayScheduleUseCase mockToday;
  late _MockGetAllExercisesUseCase mockAll;
  late _MockAuthCubit mockAuthCubit;
  late List<ExerciseEntity> todayList;
  late List<ExerciseEntity> allList;

  setUpAll(() {
    registerFallbackValue(const GetTodayScheduleParams(_userId));
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    todayList = [_ex('t1'), _ex('t2'), _ex('t3')];
    allList = [_ex('a1'), _ex('a2'), _ex('a3'), _ex('a4'), _ex('a5')];

    mockToday = _MockGetTodayScheduleUseCase();
    mockAll = _MockGetAllExercisesUseCase();

    when(() => mockToday(const GetTodayScheduleParams(_userId)))
        .thenAnswer((_) async => Right<Failure, List<ExerciseEntity>>(todayList));
    when(() => mockAll(const NoParams()))
        .thenAnswer((_) async => Right<Failure, List<ExerciseEntity>>(allList));

    // Override the DI registration for the cubit the page constructs. Each
    // factory call returns a fresh cubit so the test owns the instance.
    if (!getIt.isRegistered<ExerciseListCubit>()) {
      getIt.registerFactory<ExerciseListCubit>(
        () => ExerciseListCubit(mockToday, mockAll),
      );
    } else {
      getIt
        ..allowReassignment = true
        ..unregister<ExerciseListCubit>();
      getIt.registerFactory<ExerciseListCubit>(
        () => ExerciseListCubit(mockToday, mockAll),
      );
    }

    mockAuthCubit = _MockAuthCubit();
    final user = _buildUser();
    whenListen(
      mockAuthCubit,
      Stream<AuthState>.empty(),
      initialState: AuthState.authenticated(user),
    );
  });

  tearDown(() async {
    await mockAuthCubit.close();
    if (getIt.isRegistered<ExerciseListCubit>()) {
      await getIt.unregister<ExerciseListCubit>();
    }
  });

  testWidgets(
      'switching today → all → today does NOT push or pop navigator routes '
      '— Validates Requirements 5.1, 5.3, 5.6', (tester) async {
    final observer = _DepthObserver();

    await tester.pumpWidget(_harness(
      authCubit: mockAuthCubit,
      observer: observer,
    ));
    // First pump installs MaterialApp; second settles the loadInitial future.
    await tester.pumpAndSettle();

    // Capture navigator depth after the page has fully rendered today mode.
    final depthAfterInitial = observer.depth;
    expect(depthAfterInitial, greaterThan(0),
        reason: 'MaterialApp.home must have pushed the root route by now.');

    // Sanity check — today mode is rendered with the primary "All Exercises"
    // button (English ARB key `exerciseListAllExercises`).
    final allButton = find.text('All Exercises');
    expect(allButton, findsOneWidget);

    // Tap "All Exercises" — the page MUST switch to allMode without pushing
    // or popping any route.
    await tester.ensureVisible(allButton);
    await tester.tap(allButton);
    await tester.pumpAndSettle();

    expect(
      observer.depth,
      depthAfterInitial,
      reason: 'Switching to allMode must not change the navigator depth. '
          'Observed events: ${observer.events}',
    );

    // The "Today's Exercises" toggle is rendered at the very bottom of the
    // grouped list. Scroll the [CustomScrollView] until it is visible so the
    // tap below resolves to a real hit-test target.
    final todayButton = find.text("Today's Exercises");
    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      todayButton,
      200,
      scrollable: scrollable,
    );
    expect(todayButton, findsOneWidget);

    // Tap "Today's Exercises" — back to todayMode without navigation.
    await tester.tap(todayButton);
    await tester.pumpAndSettle();

    expect(
      observer.depth,
      depthAfterInitial,
      reason: 'Switching back to todayMode must not change the navigator '
          'depth. Observed events: ${observer.events}',
    );

    // The original mode-toggle should be visible again.
    expect(find.text('All Exercises'), findsOneWidget);

    // No replace events should have fired either — mode switching is a pure
    // state transition.
    expect(
      observer.events.any((e) => e.startsWith('replace')),
      isFalse,
      reason: 'Mode switching must not replace routes. '
          'Observed events: ${observer.events}',
    );
  });
}
