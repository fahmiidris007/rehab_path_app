import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../shared/data/datasources/dummy_data_source.dart';
import '../../../../shared/data/datasources/hive_data_source.dart';
import '../../../../shared/data/models/exercise_session_hive_model.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../../shared/domain/entities/exercise_session_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../utils/schedule_seed_generator.dart';

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
      final program =
          programs.where((p) => p.level.name == userLevel).firstOrNull;
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
      final normalizedDate = AppDateUtils.toLocalMidnight(date);
      final allExercises = await _dummyDataSource.loadExercises();
      final catalogById = {for (final ex in allExercises) ex.id: ex};

      // Try cache first.
      final cachedIds = await _hiveDataSource.getScheduleSet(
        userId,
        normalizedDate,
      );
      if (cachedIds != null && cachedIds.isNotEmpty) {
        final cachedExercises = cachedIds
            .map((id) => catalogById[id])
            .whereType<ExerciseEntity>()
            .toList();
        if (cachedExercises.length == cachedIds.length) {
          return Right(cachedExercises);
        }
        // Fall through to recompute when any cached id is missing from the
        // catalogue (e.g. catalogue updated since the schedule was cached).
        _logger.w(
          'Cached schedule for ($userId, $normalizedDate) had ids missing '
          'from the catalogue; recomputing.',
        );
      }

      // No cache: compute deterministically.
      final user = _hiveDataSource.getUser(userId);
      if (user == null) return const Right([]);

      final programLevel = ProgramLevel.values.firstWhere(
        (e) => e.name == user.programLevel,
        orElse: () => ProgramLevel.beginner,
      );

      final levelMatches = allExercises
          .where((e) => e.recommendedLevel == programLevel)
          .toList();
      if (levelMatches.isEmpty) return const Right([]);

      final targetCount =
          user.onboardingProfile?.weeklyFrequencyTarget.clamp(3, 6) ?? 4;

      final random = Random(ScheduleSeedGenerator.seed(userId, normalizedDate));

      ExerciseEntity? pickFirst(
        List<ExerciseEntity> pool,
        Random rand,
      ) {
        if (pool.isEmpty) return null;
        final shuffled = List<ExerciseEntity>.of(pool)..shuffle(rand);
        return shuffled.first;
      }

      final warmUps = levelMatches
          .where((e) => e.category == ExerciseCategory.warmUp)
          .toList();
      final coolDowns = levelMatches
          .where((e) => e.category == ExerciseCategory.coolDown)
          .toList();
      final body = levelMatches
          .where((e) =>
              e.category != ExerciseCategory.warmUp &&
              e.category != ExerciseCategory.coolDown)
          .toList();

      final warmUpPick = pickFirst(warmUps, random);
      final coolDownPick = pickFirst(coolDowns, random);

      final bodyTarget = targetCount -
          (warmUpPick != null ? 1 : 0) -
          (coolDownPick != null ? 1 : 0);

      final shuffledBody = List<ExerciseEntity>.of(body)..shuffle(random);
      final bodyPicks = shuffledBody
          .take(bodyTarget < 0 ? 0 : bodyTarget)
          .toList();

      final composed = <ExerciseEntity>[
        if (warmUpPick != null) warmUpPick,
        ...bodyPicks,
        if (coolDownPick != null) coolDownPick,
      ];

      // Final length must be in [3, 6]; if the catalogue is too small to
      // reach 3 we return whatever we have (no padding).
      final result = composed.length > 6 ? composed.sublist(0, 6) : composed;

      // Persist cache (best-effort; never fail the call).
      try {
        await _hiveDataSource.saveScheduleSet(
          userId: userId,
          date: normalizedDate,
          exerciseIds: result.map((e) => e.id).toList(),
        );
      } catch (e, st) {
        _logger.w(
          'Failed to persist schedule cache for ($userId, $normalizedDate); '
          'continuing without cache.',
          error: e,
          stackTrace: st,
        );
      }

      return Right(result);
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
