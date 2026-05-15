import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../../shared/domain/entities/motivational_message_entity.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../../../exercise/domain/usecases/get_exercises_by_level_use_case.dart';
import '../../domain/usecases/get_random_message_use_case.dart';
import '../../domain/usecases/get_streak_use_case.dart';
import '../../domain/usecases/get_today_schedule_use_case.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetRandomMessageUseCase _getMessageUseCase;
  final GetStreakUseCase _getStreakUseCase;
  final GetTodayScheduleUseCase _getTodayScheduleUseCase;
  final GetExercisesByLevelUseCase _getExercisesByLevelUseCase;

  bool _isNavigating = false;

  HomeCubit(
    this._getMessageUseCase,
    this._getStreakUseCase,
    this._getTodayScheduleUseCase,
    this._getExercisesByLevelUseCase,
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

      emit(HomeState.loaded(HomeData(
        user: user,
        streakDays: streak,
        todaySchedule: todaySchedule,
        completedToday: 0, // Will be updated as sessions are completed
        recommendedExercises: recommended.take(5).toList(),
        motivationalMessage: message,
        completedDaysThisWeek: [],
        totalMinutes: 0,
        totalSessions: 0,
      )));
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
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
}
