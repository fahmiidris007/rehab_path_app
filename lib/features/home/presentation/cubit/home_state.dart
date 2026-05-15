import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../../shared/domain/entities/motivational_message_entity.dart';
import '../../../../shared/domain/entities/user_entity.dart';

part 'home_state.freezed.dart';

@freezed
class HomeData with _$HomeData {
  const factory HomeData({
    required UserEntity user,
    required int streakDays,
    required List<ExerciseEntity> todaySchedule,
    required int completedToday,
    required List<ExerciseEntity> recommendedExercises,
    required MotivationalMessageEntity motivationalMessage,
    required List<DateTime> completedDaysThisWeek,
    required int totalMinutes,
    required int totalSessions,
  }) = _HomeData;
}

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.loaded(HomeData data) = HomeLoaded;
  const factory HomeState.error(String message) = HomeError;
}
