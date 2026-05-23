import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../../shared/domain/entities/motivational_message_entity.dart';
import '../../../../shared/domain/entities/user_entity.dart';

part 'home_state.freezed.dart';

@freezed
class HomeData with _$HomeData {
  const HomeData._();

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
    required DateTime selectedDate,
    required DateTime todayLocal,
    required List<ExerciseEntity> selectedDateSchedule,
    required int selectedDateCompleted,
  }) = _HomeData;

  bool get isViewingPastOrFutureDate =>
      !AppDateUtils.isSameDay(selectedDate, todayLocal);

  int get progressRingPercent {
    final scheduleLen = selectedDateSchedule.length;
    if (scheduleLen == 0) return 0;
    return ((selectedDateCompleted / scheduleLen) * 100).round();
  }
}

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.loaded(HomeData data) = HomeLoaded;
  const factory HomeState.error(String message) = HomeError;
}
