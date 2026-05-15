import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants/app_constants.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/entities/motivational_message_entity.dart';
import '../../domain/entities/program_entity.dart';
import '../../domain/entities/progress_data_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../models/exercise_json_model.dart';
import '../models/message_json_model.dart';
import '../models/program_json_model.dart';
import '../models/progress_json_model.dart';
import '../models/user_json_model.dart';

/// Reads all 5 JSON asset files and parses them into domain entities.
@lazySingleton
class DummyDataSource {
  Future<List<UserEntity>> loadUsers() async {
    final jsonString =
        await rootBundle.loadString(AppConstants.assetDummyUsers);
    final list = jsonDecode(jsonString) as List<dynamic>;
    return list
        .map(
          (e) => UserJsonModel.fromJson(e as Map<String, dynamic>).toEntity(),
        )
        .toList();
  }

  Future<List<ExerciseEntity>> loadExercises() async {
    final jsonString =
        await rootBundle.loadString(AppConstants.assetDummyExercises);
    final list = jsonDecode(jsonString) as List<dynamic>;
    return list
        .map(
          (e) =>
              ExerciseJsonModel.fromJson(e as Map<String, dynamic>).toEntity(),
        )
        .toList();
  }

  Future<List<ProgramEntity>> loadPrograms() async {
    final jsonString =
        await rootBundle.loadString(AppConstants.assetDummyPrograms);
    final list = jsonDecode(jsonString) as List<dynamic>;
    return list
        .map(
          (e) =>
              ProgramJsonModel.fromJson(e as Map<String, dynamic>).toEntity(),
        )
        .toList();
  }

  Future<ProgressDataEntity> loadProgress() async {
    final jsonString =
        await rootBundle.loadString(AppConstants.assetDummyProgress);
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return ProgressJsonModel.fromJson(map).toEntity();
  }

  Future<List<MotivationalMessageEntity>> loadMessages() async {
    final jsonString =
        await rootBundle.loadString(AppConstants.assetDummyMessages);
    final list = jsonDecode(jsonString) as List<dynamic>;
    return list
        .map(
          (e) =>
              MessageJsonModel.fromJson(e as Map<String, dynamic>).toEntity(),
        )
        .toList();
  }
}
