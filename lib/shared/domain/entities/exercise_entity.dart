import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/app_enums.dart';

part 'exercise_entity.freezed.dart';

@freezed
class ExerciseEntity with _$ExerciseEntity {
  const factory ExerciseEntity({
    required String id,
    required String name,
    required ExerciseCategory category,
    required String description,
    required List<String> steps,
    required int durationSeconds,
    required int sets,
    required int reps,
    required int difficulty,
    required List<String> safetyTips,
    required String imagePath,
    ProgramLevel? recommendedLevel,
  }) = _ExerciseEntity;
}
