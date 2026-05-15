import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/app_enums.dart';

part 'exercise_session_entity.freezed.dart';

@freezed
class ExerciseSessionEntity with _$ExerciseSessionEntity {
  const factory ExerciseSessionEntity({
    required String id,
    required String exerciseId,
    required String userId,
    required DateTime completedAt,
    required BodyCondition bodyCondition,
    required SupportUsed supportUsed,
  }) = _ExerciseSessionEntity;
}
