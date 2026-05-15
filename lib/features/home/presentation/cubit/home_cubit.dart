import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/use_case.dart';
import '../../../../shared/data/datasources/hive_data_source.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../../shared/domain/entities/motivational_message_entity.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../../../exercise/domain/usecases/get_exercises_by_level_use_case.dart';
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
  final HiveDataSource _hiveDataSource;

  bool _isNavigating = false;

  HomeCubit(
    this._getMessageUseCase,
    this._getStreakUseCase,
    this._getTodayScheduleUseCase,
    this._getExercisesByLevelUseCase,
    this._hiveDataSource,
  ) : super(const HomeState.loading());

  Future<void> loadDashboard(UserEntity user) async {
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

      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final completedToday = allSessions
          .where((s) => s.completedAt.isAfter(todayStart))
          .length;

      final monday = today.subtract(Duration(days: today.weekday - 1));
      final mondayStart = DateTime(monday.year, monday.month, monday.day);
      final completedDaysThisWeek = allSessions
          .where((s) => s.completedAt.isAfter(mondayStart))
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
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

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

    // If still not loaded after waiting, nothing to refresh.
    if (state is! HomeLoaded) return;

    final data = (state as HomeLoaded).data;
    final userId = data.user.id;

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

    // Count sessions completed today
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final completedToday = allSessions
        .where((s) => s.completedAt.isAfter(todayStart))
        .length;

    // Collect unique completed days this week (Mon–Sun)
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final mondayStart = DateTime(monday.year, monday.month, monday.day);
    final completedDaysThisWeek = allSessions
        .where((s) => s.completedAt.isAfter(mondayStart))
        .map((s) {
          final d = s.completedAt;
          return DateTime(d.year, d.month, d.day);
        })
        .toSet()
        .toList();

    emit(HomeState.loaded(data.copyWith(
      streakDays: newStreak,
      completedToday: completedToday,
      totalSessions: totalSessions,
      totalMinutes: totalMinutes,
      completedDaysThisWeek: completedDaysThisWeek,
    )));
  }
}
