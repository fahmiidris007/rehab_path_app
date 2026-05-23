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

  /// Returns the deterministic exercise schedule for `(userId, date)`.
  ///
  /// Implementation contract:
  /// - `date` is normalized to local midnight via
  ///   `AppDateUtils.toLocalMidnight` before any lookups or hashing, so any
  ///   time-of-day component on the same calendar day yields the same result.
  /// - If a cached `ScheduledExerciseSetHiveModel` exists for `(userId, date)`
  ///   it is returned directly, falling back to the seeded computation if any
  ///   cached id is missing from the catalogue.
  /// - The seeded computation uses `Random(ScheduleSeedGenerator.seed(...))`
  ///   to pick 1 warm-up, the body items, and 1 cool-down deterministically.
  /// - Final length is in `[3, 6]`. If the user has no `programLevel` or the
  ///   matching catalogue is empty, returns `Right([])`. If the catalogue has
  ///   fewer than 3 entries, the shorter list is returned as-is.
  Future<Either<Failure, List<ExerciseEntity>>> getScheduleForDate({
    required String userId,
    required DateTime date,
  });

  Future<Either<Failure, Unit>> saveSession(ExerciseSessionEntity session);

  Future<Either<Failure, Unit>> deletePartialSession(String sessionId);
}
