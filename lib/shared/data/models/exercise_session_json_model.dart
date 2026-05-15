import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/exercise_session_entity.dart';
import '../../domain/enums/app_enums.dart';

part 'exercise_session_json_model.g.dart';

@JsonSerializable()
class ExerciseSessionJsonModel {
  final String id;
  final String exerciseId;
  final String userId;
  final String completedAt;
  final String bodyCondition;
  final String supportUsed;

  const ExerciseSessionJsonModel({
    required this.id,
    required this.exerciseId,
    required this.userId,
    required this.completedAt,
    required this.bodyCondition,
    required this.supportUsed,
  });

  factory ExerciseSessionJsonModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseSessionJsonModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseSessionJsonModelToJson(this);

  ExerciseSessionEntity toEntity() {
    return ExerciseSessionEntity(
      id: id,
      exerciseId: exerciseId,
      userId: userId,
      completedAt: DateTime.parse(completedAt),
      bodyCondition: BodyCondition.values.firstWhere(
        (e) => e.name == bodyCondition,
        orElse: () => BodyCondition.sitting,
      ),
      supportUsed: SupportUsed.values.firstWhere(
        (e) => e.name == supportUsed,
        orElse: () => SupportUsed.noSupport,
      ),
    );
  }
}
