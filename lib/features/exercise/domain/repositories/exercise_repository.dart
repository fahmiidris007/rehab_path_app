import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../../shared/domain/entities/exercise_session_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';

abstract class ExerciseRepository {
  Future<Either<Failure, List<ExerciseEntity>>> getAllExercises();

  Future<Either<Failure, ExerciseEntity>> getExerciseById(String id);

  Future<Either<Failure, List<ExerciseEntity>>> getExercisesByLevel(
    ProgramLevel level,
  );

  Future<Either<Failure, List<ExerciseEntity>>> getTodaySchedule(String userId);

  Future<Either<Failure, Unit>> saveSession(ExerciseSessionEntity session);

  Future<Either<Failure, Unit>> deletePartialSession(String sessionId);
}
