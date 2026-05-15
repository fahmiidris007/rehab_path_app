import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/entities/badge_entity.dart';
import '../../../../shared/domain/entities/balance_score_point.dart';
import '../../../../shared/domain/entities/exercise_session_entity.dart';
import '../../../../shared/domain/entities/fall_event_entity.dart';

abstract class ProgressRepository {
  Future<Either<Failure, List<ExerciseSessionEntity>>> getSessionsForWeek(
      DateTime weekStart);

  Future<Either<Failure, List<ExerciseSessionEntity>>> getSessionsForMonth(
      DateTime month);

  Future<Either<Failure, List<BalanceScorePoint>>> getBalanceScores(
      String userId);

  Future<Either<Failure, Unit>> logFallEvent(FallEventEntity event);

  Future<Either<Failure, Unit>> removeFallEvent(String eventId);

  Future<Either<Failure, List<FallEventEntity>>> getFallEventsForMonth(
      DateTime month);

  Future<Either<Failure, List<BadgeEntity>>> getBadges(String userId);

  Future<Either<Failure, Unit>> awardBadge(String userId, String badgeId);
}
