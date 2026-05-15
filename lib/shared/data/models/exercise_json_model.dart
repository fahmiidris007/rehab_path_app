import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/exercise_entity.dart';
import '../../domain/enums/app_enums.dart';

part 'exercise_json_model.g.dart';

@JsonSerializable()
class ExerciseJsonModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final List<String> steps;
  final int durationSeconds;
  final int sets;
  final int reps;
  final int difficulty;
  final List<String> safetyTips;
  final String imagePath;
  final String? recommendedLevel;

  const ExerciseJsonModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.steps,
    required this.durationSeconds,
    required this.sets,
    required this.reps,
    required this.difficulty,
    required this.safetyTips,
    required this.imagePath,
    this.recommendedLevel,
  });

  factory ExerciseJsonModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseJsonModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseJsonModelToJson(this);

  ExerciseEntity toEntity() {
    return ExerciseEntity(
      id: id,
      name: name,
      category: _categoryFromString(category),
      description: description,
      steps: steps,
      durationSeconds: durationSeconds,
      sets: sets,
      reps: reps,
      difficulty: difficulty,
      safetyTips: safetyTips,
      imagePath: imagePath,
      recommendedLevel: recommendedLevel != null
          ? ProgramLevel.values.firstWhere(
              (e) => e.name == recommendedLevel,
              orElse: () => ProgramLevel.beginner,
            )
          : null,
    );
  }
}

ExerciseCategory _categoryFromString(String s) {
  return ExerciseCategory.values.firstWhere(
    (e) => e.name == s,
    orElse: () => ExerciseCategory.warmUp,
  );
}
