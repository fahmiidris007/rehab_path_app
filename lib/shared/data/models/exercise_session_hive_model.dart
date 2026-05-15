import 'package:hive/hive.dart';

import '../../domain/entities/exercise_session_entity.dart';
import '../../domain/enums/app_enums.dart';

part 'exercise_session_hive_model.g.dart';

@HiveType(typeId: 3)
class ExerciseSessionHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String exerciseId;

  @HiveField(2)
  String userId;

  @HiveField(3)
  DateTime completedAt;

  @HiveField(4)
  String bodyCondition;

  @HiveField(5)
  String supportUsed;

  ExerciseSessionHiveModel({
    required this.id,
    required this.exerciseId,
    required this.userId,
    required this.completedAt,
    required this.bodyCondition,
    required this.supportUsed,
  });

  ExerciseSessionEntity toEntity() {
    return ExerciseSessionEntity(
      id: id,
      exerciseId: exerciseId,
      userId: userId,
      completedAt: completedAt,
      bodyCondition: BodyCondition.values.firstWhere(
        (e) => e.name == bodyCondition,
        orElse: () => BodyCondition.standing,
      ),
      supportUsed: SupportUsed.values.firstWhere(
        (e) => e.name == supportUsed,
        orElse: () => SupportUsed.noSupport,
      ),
    );
  }

  static ExerciseSessionHiveModel fromEntity(ExerciseSessionEntity entity) {
    return ExerciseSessionHiveModel(
      id: entity.id,
      exerciseId: entity.exerciseId,
      userId: entity.userId,
      completedAt: entity.completedAt,
      bodyCondition: entity.bodyCondition.name,
      supportUsed: entity.supportUsed.name,
    );
  }
}
