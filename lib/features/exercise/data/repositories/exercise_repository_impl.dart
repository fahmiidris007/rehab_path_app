import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/data/datasources/dummy_data_source.dart';
import '../../../../shared/data/datasources/hive_data_source.dart';
import '../../../../shared/data/models/exercise_session_hive_model.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../../shared/domain/entities/exercise_session_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../../domain/repositories/exercise_repository.dart';

@LazySingleton(as: ExerciseRepository)
class ExerciseRepositoryImpl implements ExerciseRepository {
  final DummyDataSource _dummyDataSource;
  final HiveDataSource _hiveDataSource;
  final Logger _logger;

  ExerciseRepositoryImpl(
    this._dummyDataSource,
    this._hiveDataSource,
    this._logger,
  );

  @override
  Future<Either<Failure, List<ExerciseEntity>>> getAllExercises() async {
    try {
      final exercises = await _dummyDataSource.loadExercises();
      return Right(exercises);
    } catch (e, st) {
      _logger.e('GetAllExercises failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExerciseEntity>> getExerciseById(String id) async {
    try {
      final exercises = await _dummyDataSource.loadExercises();
      final exercise = exercises.where((e) => e.id == id).firstOrNull;
      if (exercise == null) {
        return Left(Failure.cache(message: 'Exercise not found: $id'));
      }
      return Right(exercise);
    } catch (e, st) {
      _logger.e('GetExerciseById failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExerciseEntity>>> getExercisesByLevel(
    ProgramLevel level,
  ) async {
    try {
      final exercises = await _dummyDataSource.loadExercises();
      return Right(
        exercises.where((e) => e.recommendedLevel == level).toList(),
      );
    } catch (e, st) {
      _logger.e('GetExercisesByLevel failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExerciseEntity>>> getTodaySchedule(
    String userId,
  ) async {
    try {
      // Get user's program level from Hive
      final user = _hiveDataSource.getUser(userId);
      if (user == null) return const Right([]);

      // Load programs and find the one matching user's level
      final programs = await _dummyDataSource.loadPrograms();
      final userLevel = user.programLevel; // string like "beginner"
      final program = programs
          .where((p) => p.level.name == userLevel)
          .firstOrNull;
      if (program == null) return const Right([]);

      // Get today's day of week (1=Monday, 7=Sunday)
      final dayOfWeek = DateTime.now().weekday; // 1=Mon, 7=Sun
      final todayExerciseIds = program.weeklySchedule[dayOfWeek] ?? [];

      // Load all exercises and filter by today's IDs
      final allExercises = await _dummyDataSource.loadExercises();
      final todayExercises = todayExerciseIds
          .map((id) => allExercises.where((e) => e.id == id).firstOrNull)
          .whereType<ExerciseEntity>()
          .toList();

      return Right(todayExercises);
    } catch (e, st) {
      _logger.e('GetTodaySchedule failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExerciseEntity>>> getScheduleForDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      // Fixed-order schedule: return all exercises in their catalogue order.
      // No randomness — exercises are displayed in the same sequence as
      // defined in dummy_exercises.json (pemanasan → keseimbangan →
      // kekuatan → pendinginan).
      final allExercises = await _dummyDataSource.loadExercises();
      return Right(allExercises);
    } catch (e, st) {
      _logger.e('GetScheduleForDate failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSession(
    ExerciseSessionEntity session,
  ) async {
    try {
      await _hiveDataSource.saveSession(
        ExerciseSessionHiveModel.fromEntity(session),
      );
      return const Right(unit);
    } catch (e, st) {
      _logger.e('SaveSession failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePartialSession(String sessionId) async {
    try {
      await _hiveDataSource.deleteSession(sessionId);
      return const Right(unit);
    } catch (e, st) {
      _logger.e('DeletePartialSession failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }
}
