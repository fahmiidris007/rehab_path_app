import 'package:freezed_annotation/freezed_annotation.dart';

import 'balance_score_point.dart';
import 'exercise_session_entity.dart';

part 'progress_data_entity.freezed.dart';

@freezed
class ProgressDataEntity with _$ProgressDataEntity {
  const factory ProgressDataEntity({
    required String userId,
    required List<BalanceScorePoint> balanceScores,
    required List<ExerciseSessionEntity> sessions,
  }) = _ProgressDataEntity;
}
