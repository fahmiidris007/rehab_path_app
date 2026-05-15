import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/domain/entities/badge_entity.dart';
import '../../../../shared/domain/entities/balance_score_point.dart';
import '../../../../shared/domain/entities/fall_event_entity.dart';
import '../../../../shared/domain/entities/exercise_session_entity.dart';

part 'progress_state.freezed.dart';

@freezed
class ProgressViewData with _$ProgressViewData {
  const factory ProgressViewData({
    required double weeklyAdherenceRate,
    required double monthlyAdherenceRate,
    required List<BalanceScorePoint> balanceScores,
    required List<FallEventEntity> fallEventsThisMonth,
    required List<BadgeEntity> badges,
    required List<ExerciseSessionEntity> recentSessions,
    required Set<String> workedMuscleGroups,
  }) = _ProgressViewData;
}

@freezed
sealed class ProgressState with _$ProgressState {
  const factory ProgressState.loading() = ProgressLoading;
  const factory ProgressState.loaded(ProgressViewData data) = ProgressLoaded;
  const factory ProgressState.error(String message) = ProgressError;
}
