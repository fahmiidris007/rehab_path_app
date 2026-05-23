import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/use_case.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../shared/data/datasources/hive_data_source.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../../shared/domain/entities/motivational_message_entity.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../../../exercise/domain/usecases/get_exercises_by_level_use_case.dart';
import '../../../exercise/domain/usecases/get_schedule_for_date_use_case.dart';
import '../../domain/usecases/get_random_message_use_case.dart';
import '../../domain/usecases/get_streak_use_case.dart';
import '../../domain/usecases/get_today_schedule_use_case.dart';
import 'home_state.dart';

@lazySingleton
class HomeCubit extends Cubit<HomeState> {
  final GetRandomMessageUseCase _getMessageUseCase;
  final GetStreakUseCase _getStreakUseCase;
  final GetTodayScheduleUseCase _getTodayScheduleUseCase;
  final GetExercisesByLevelUseCase _getExercisesByLevelUseCase;
  final GetScheduleForDateUseCase _getScheduleForDateUseCase;
  final HiveDataSource _hiveDataSource;

  bool _isNavigating = false;

  /// Tracks the most recently loaded user so [refreshAfterSession] can
  /// fall back to a full [loadDashboard] if the cubit is still in
  /// [HomeLoading] after polling. This guarantees the cubit never leaves
  /// observers stuck on a loading state after a session save.
  UserEntity? _lastLoadedUser;

  HomeCubit(
    this._getMessageUseCase,
    this._getStreakUseCase,
    this._getTodayScheduleUseCase,
    this._getExercisesByLevelUseCase,
    this._getScheduleForDateUseCase,
    this._hiveDataSource,
  ) : super(const HomeState.loading());

  Future<void> loadDashboard(UserEntity user) async {
    _lastLoadedUser = user;
    emit(const HomeState.loading());
    try {
      // Load all data in parallel
      final results = await Future.wait([
        _getMessageUseCase(const NoParams()),
        _getStreakUseCase(GetStreakParams(userId: user.id)),
        _getTodayScheduleUseCase(GetTodayScheduleParams(userId: user.id)),
        _getExercisesByLevelUseCase(GetExercisesByLevelParams(user.programLevel)),
      ]);

      final message = results[0].fold(
        (_) => const MotivationalMessageEntity(
          id: 'default',
          textEn: 'Keep going!',
          textId: 'Terus semangat!',
          category: 'encouragement',
        ),
        (v) => v as MotivationalMessageEntity,
      );
      final streak = results[1].fold((_) => 0, (v) => v as int);
      final todaySchedule = results[2].fold(
        (_) => <ExerciseEntity>[],
        (v) => v as List<ExerciseEntity>,
      );
      final recommended = results[3].fold(
        (_) => <ExerciseEntity>[],
        (v) => v as List<ExerciseEntity>,
      );

      // Set of exercise IDs scheduled for today. Aggregation against the
      // dashboard ring/streak considers ONLY sessions whose exerciseId is in
      // this set (R6.1–R6.4). Out-of-schedule sessions are still saved in
      // Hive but are intentionally ignored here.
      final todayScheduleIds = todaySchedule.map((e) => e.id).toSet();

      // Compute stats from existing Hive sessions on initial load
      final allSessions = _hiveDataSource
          .getAllSessions()
          .where((s) => s.userId == user.id)
          .toList();

      final totalSessions = allSessions.length;

      final exerciseDurationMap = <String, int>{
        for (final e in todaySchedule) e.id: (e.durationSeconds / 60).ceil(),
      };
      final totalMinutes = allSessions.fold<int>(0, (sum, s) {
        final mins = exerciseDurationMap[s.exerciseId] ?? 10;
        return sum + mins;
      });

      final todayLocal = AppDateUtils.todayLocal();
      final todayStart = todayLocal;
      final completedToday = allSessions
          .where((s) =>
              s.completedAt.isAfter(todayStart) &&
              todayScheduleIds.contains(s.exerciseId))
          .length;

      // Weekly aggregation uses today's schedule as a proxy for "in-schedule"
      // membership across the week. A precise per-day membership check would
      // require looking up each prior day's ScheduledExerciseSetHiveModel
      // cache; per design.md we accept this approximation for now.
      final monday =
          todayLocal.subtract(Duration(days: todayLocal.weekday - 1));
      final mondayStart = DateTime(monday.year, monday.month, monday.day);
      final completedDaysThisWeek = allSessions
          .where((s) =>
              s.completedAt.isAfter(mondayStart) &&
              todayScheduleIds.contains(s.exerciseId))
          .map((s) {
            final d = s.completedAt;
            return DateTime(d.year, d.month, d.day);
          })
          .toSet()
          .toList();

      emit(HomeState.loaded(HomeData(
        user: user,
        streakDays: streak,
        todaySchedule: todaySchedule,
        completedToday: completedToday,
        recommendedExercises: recommended.take(5).toList(),
        motivationalMessage: message,
        completedDaysThisWeek: completedDaysThisWeek,
        totalMinutes: totalMinutes,
        totalSessions: totalSessions,
        selectedDate: todayLocal,
        todayLocal: todayLocal,
        selectedDateSchedule: todaySchedule,
        selectedDateCompleted: completedToday,
      )));
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }

  /// Returns the next exercise in today's schedule that has not been completed
  /// today, or `null` if all exercises are done.
  ///
  /// "Completed today" means there is at least one [ExerciseSessionEntity] in
  /// Hive for this user whose [exerciseId] matches and whose [completedAt] is
  /// after midnight today.
  ExerciseEntity? getNextIncompleteExercise() {
    if (state is! HomeLoaded) return null;
    final data = (state as HomeLoaded).data;
    if (data.todaySchedule.isEmpty) return null;

    final userId = data.user.id;
    final todayStart = AppDateUtils.todayLocal();

    final completedExerciseIds = _hiveDataSource
        .getAllSessions()
        .where((s) => s.userId == userId && s.completedAt.isAfter(todayStart))
        .map((s) => s.exerciseId)
        .toSet();

    return data.todaySchedule.firstWhere(
      (e) => !completedExerciseIds.contains(e.id),
      orElse: () => data.todaySchedule.last, // all done — return last as fallback
    );
  }

  /// Returns `true` if all exercises in today's schedule have been completed.
  bool get allTodayExercisesDone {
    if (state is! HomeLoaded) return false;
    final data = (state as HomeLoaded).data;
    if (data.todaySchedule.isEmpty) return false;
    return data.completedToday >= data.todaySchedule.length;
  }

  /// Debounced navigation guard — prevents duplicate taps within 300ms.
  bool get canNavigate => !_isNavigating;

  void startNavigation() {
    if (_isNavigating) return;
    _isNavigating = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      _isNavigating = false;
    });
  }

  void updateCompletedToday(int count) {
    if (state is HomeLoaded) {
      final data = (state as HomeLoaded).data;
      emit(HomeState.loaded(data.copyWith(completedToday: count)));
    }
  }

  /// Switches the dashboard's view-mode to the given [date] (R9.2–R9.8).
  ///
  /// This is a **read-only** view-mode: it never mutates `completedToday`,
  /// `streakDays`, `totalSessions`, `totalMinutes`, or `completedDaysThisWeek`,
  /// nor does it write to Hive. Only `selectedDate`, `selectedDateSchedule`,
  /// and `selectedDateCompleted` are recomputed.
  ///
  /// Behavior:
  /// - If state is not [HomeLoaded], returns immediately.
  /// - The schedule for [date] is fetched via [GetScheduleForDateUseCase].
  ///   On a Left result, an empty list is used.
  /// - For dates strictly **after** today, the ring stays at 0 (R9.6) by
  ///   forcing `selectedDateCompleted = 0` and `selectedDateSchedule = []`.
  /// - Otherwise `selectedDateCompleted` counts the user's sessions whose
  ///   `completedAt` falls on the local calendar [date] AND whose
  ///   `exerciseId` is in the selected date's schedule.
  Future<void> selectDate(DateTime date) async {
    if (state is! HomeLoaded) return;
    final data = (state as HomeLoaded).data;

    final localDate = AppDateUtils.toLocalMidnight(date);
    final todayLocal = data.todayLocal;

    // Future date → R9.6: ring is 0%, no schedule rendered as "today's plan".
    if (localDate.isAfter(todayLocal)) {
      emit(HomeState.loaded(data.copyWith(
        selectedDate: localDate,
        selectedDateSchedule: const <ExerciseEntity>[],
        selectedDateCompleted: 0,
      )));
      return;
    }

    final scheduleResult = await _getScheduleForDateUseCase(
      GetScheduleForDateParams(userId: data.user.id, date: localDate),
    );
    final selectedDateSchedule = scheduleResult.fold(
      (_) => <ExerciseEntity>[],
      (v) => v,
    );

    final selectedScheduleIds =
        selectedDateSchedule.map((e) => e.id).toSet();

    final dayStart = localDate;
    final dayEnd = localDate.add(const Duration(days: 1));
    final selectedDateCompleted = _hiveDataSource
        .getAllSessions()
        .where((s) =>
            s.userId == data.user.id &&
            !s.completedAt.isBefore(dayStart) &&
            s.completedAt.isBefore(dayEnd) &&
            selectedScheduleIds.contains(s.exerciseId))
        .length;

    emit(HomeState.loaded(data.copyWith(
      selectedDate: localDate,
      selectedDateSchedule: selectedDateSchedule,
      selectedDateCompleted: selectedDateCompleted,
    )));
  }

  /// Resets the dashboard's view-mode back to today (R9.7).
  Future<void> resetToToday() => selectDate(AppDateUtils.todayLocal());

  /// Called after an exercise session is saved.
  ///
  /// Re-computes streak, completedToday, totalSessions, and totalMinutes
  /// from the Hive session store so the dashboard reflects the latest data
  /// without a full reload.
  Future<void> refreshAfterSession() async {
    // Wait for the cubit to be in a loaded state before refreshing.
    // This handles the case where loadDashboard is still in progress.
    if (state is HomeLoading) {
      // Poll until loaded (max 3 seconds)
      int attempts = 0;
      while (state is HomeLoading && attempts < 30) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }
    }

    // Fallback: if we are STILL in HomeLoading after polling (e.g. the
    // initial loadDashboard never completed because no listener triggered
    // it), kick off a fresh loadDashboard for the last known user so the
    // cubit never leaves observers stranded on a loading state.
    // Guarantees a non-loading terminal state for callers awaiting this
    // method (R11.5, R11.6).
    if (state is HomeLoading && _lastLoadedUser != null) {
      await loadDashboard(_lastLoadedUser!);
      return;
    }

    // If still not loaded after waiting (e.g. error state, or loading with
    // no _lastLoadedUser), nothing more to refresh.
    if (state is! HomeLoaded) return;

    final data = (state as HomeLoaded).data;
    final userId = data.user.id;

    // Set of in-schedule exercise IDs for today (R6.1–R6.4).
    final todayScheduleIds = data.todaySchedule.map((e) => e.id).toSet();

    // Fetch updated streak
    final streakResult =
        await _getStreakUseCase(GetStreakParams(userId: userId));
    final newStreak = streakResult.getOrElse(() => data.streakDays);

    // Compute stats from all sessions in Hive for this user
    final allSessions = _hiveDataSource
        .getAllSessions()
        .where((s) => s.userId == userId)
        .toList();

    final totalSessions = allSessions.length;

    // Compute total minutes using actual exercise durations from today's
    // schedule. For sessions not in today's schedule, fall back to 10 min.
    final exerciseDurationMap = <String, int>{
      for (final e in data.todaySchedule) e.id: (e.durationSeconds / 60).ceil(),
    };
    final totalMinutes = allSessions.fold<int>(0, (sum, s) {
      final mins = exerciseDurationMap[s.exerciseId] ?? 10;
      return sum + mins;
    });

    // Count sessions completed today that are in today's schedule (R6.2).
    final todayLocal = AppDateUtils.todayLocal();
    final todayStart = todayLocal;
    final completedToday = allSessions
        .where((s) =>
            s.completedAt.isAfter(todayStart) &&
            todayScheduleIds.contains(s.exerciseId))
        .length;

    // Collect unique completed days this week (Mon–Sun), restricted to
    // today's schedule as a per-day membership proxy. See loadDashboard for
    // rationale (avoids per-day cache lookup overhead).
    final monday =
        todayLocal.subtract(Duration(days: todayLocal.weekday - 1));
    final mondayStart = DateTime(monday.year, monday.month, monday.day);
    final completedDaysThisWeek = allSessions
        .where((s) =>
            s.completedAt.isAfter(mondayStart) &&
            todayScheduleIds.contains(s.exerciseId))
        .map((s) {
          final d = s.completedAt;
          return DateTime(d.year, d.month, d.day);
        })
        .toSet()
        .toList();

    // If user is currently viewing today, keep selectedDateCompleted in sync
    // with completedToday so the ring updates immediately. If they're viewing
    // another date, don't touch view-mode fields (R9.8).
    final isViewingToday =
        AppDateUtils.isSameDay(data.selectedDate, todayLocal);

    emit(HomeState.loaded(data.copyWith(
      streakDays: newStreak,
      completedToday: completedToday,
      totalSessions: totalSessions,
      totalMinutes: totalMinutes,
      completedDaysThisWeek: completedDaysThisWeek,
      selectedDateCompleted:
          isViewingToday ? completedToday : data.selectedDateCompleted,
      selectedDateSchedule: isViewingToday
          ? data.todaySchedule
          : data.selectedDateSchedule,
    )));
  }
}
