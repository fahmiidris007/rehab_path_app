import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/data/datasources/dummy_data_source.dart';
import '../../../../shared/data/datasources/hive_data_source.dart';
import '../../../../shared/data/models/badge_hive_model.dart';
import '../../../../shared/data/models/fall_event_hive_model.dart';
import '../../../../shared/domain/entities/badge_entity.dart';
import '../../../../shared/domain/entities/balance_score_point.dart';
import '../../../../shared/domain/entities/exercise_session_entity.dart';
import '../../../../shared/domain/entities/fall_event_entity.dart';
import '../../domain/repositories/progress_repository.dart';

@LazySingleton(as: ProgressRepository)
class ProgressRepositoryImpl implements ProgressRepository {
  final HiveDataSource _hiveDataSource;
  final DummyDataSource _dummyDataSource;
  final Logger _logger;

  ProgressRepositoryImpl(
      this._hiveDataSource, this._dummyDataSource, this._logger);

  @override
  Future<Either<Failure, List<ExerciseSessionEntity>>> getSessionsForWeek(
      DateTime weekStart) async {
    try {
      // Normalize to Monday of the week
      final monday =
          weekStart.subtract(Duration(days: weekStart.weekday - 1));
      final sunday = monday.add(const Duration(days: 6));
      final mondayDate = DateTime(monday.year, monday.month, monday.day);
      final sundayEnd =
          DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);

      final sessions = _hiveDataSource
          .getAllSessions()
          .where((s) =>
              s.completedAt.isAfter(
                  mondayDate.subtract(const Duration(seconds: 1))) &&
              s.completedAt
                  .isBefore(sundayEnd.add(const Duration(seconds: 1))))
          .map((s) => s.toEntity())
          .toList();
      return Right(sessions);
    } catch (e, st) {
      _logger.e('GetSessionsForWeek failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExerciseSessionEntity>>> getSessionsForMonth(
      DateTime month) async {
    try {
      final firstDay = DateTime(month.year, month.month, 1);
      final lastDay =
          DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final sessions = _hiveDataSource
          .getAllSessions()
          .where((s) =>
              s.completedAt.isAfter(
                  firstDay.subtract(const Duration(seconds: 1))) &&
              s.completedAt
                  .isBefore(lastDay.add(const Duration(seconds: 1))))
          .map((s) => s.toEntity())
          .toList();
      return Right(sessions);
    } catch (e, st) {
      _logger.e('GetSessionsForMonth failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BalanceScorePoint>>> getBalanceScores(
      String userId) async {
    try {
      final progress = await _dummyDataSource.loadProgress();
      return Right(progress.balanceScores);
    } catch (e, st) {
      _logger.e('GetBalanceScores failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logFallEvent(FallEventEntity event) async {
    try {
      await _hiveDataSource
          .saveFallEvent(FallEventHiveModel.fromEntity(event));
      return const Right(unit);
    } catch (e, st) {
      _logger.e('LogFallEvent failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFallEvent(String eventId) async {
    try {
      await _hiveDataSource.deleteFallEvent(eventId);
      return const Right(unit);
    } catch (e, st) {
      _logger.e('RemoveFallEvent failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FallEventEntity>>> getFallEventsForMonth(
      DateTime month) async {
    try {
      final firstDay = DateTime(month.year, month.month, 1);
      final lastDay =
          DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final events = _hiveDataSource
          .getAllFallEvents()
          .where((e) =>
              e.date.isAfter(
                  firstDay.subtract(const Duration(seconds: 1))) &&
              e.date.isBefore(lastDay.add(const Duration(seconds: 1))))
          .map((e) => e.toEntity())
          .toList();
      return Right(events);
    } catch (e, st) {
      _logger.e('GetFallEventsForMonth failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BadgeEntity>>> getBadges(String userId) async {
    try {
      // Return predefined badge definitions with earned status from Hive
      final earnedBadges = _hiveDataSource
          .getAllBadges()
          .where((b) => b.isEarned)
          .map((b) => b.id)
          .toSet();

      final allBadges = [
        BadgeEntity(
          id: 'first_session',
          name: 'First Session',
          iconPath: 'assets/images/badges/first_session.png',
          unlockCondition: 'Complete your first exercise session',
          isEarned: earnedBadges.contains('first_session'),
        ),
        BadgeEntity(
          id: '7_day_streak',
          name: '7-Day Streak',
          iconPath: 'assets/images/badges/streak_7.png',
          unlockCondition: 'Maintain a 7-day exercise streak',
          isEarned: earnedBadges.contains('7_day_streak'),
        ),
        BadgeEntity(
          id: '30_sessions',
          name: '30 Sessions',
          iconPath: 'assets/images/badges/sessions_30.png',
          unlockCondition: 'Complete 30 exercise sessions',
          isEarned: earnedBadges.contains('30_sessions'),
        ),
      ];
      return Right(allBadges);
    } catch (e, st) {
      _logger.e('GetBadges failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> awardBadge(
      String userId, String badgeId) async {
    try {
      final existing = _hiveDataSource
          .getAllBadges()
          .where((b) => b.id == badgeId)
          .firstOrNull;

      if (existing != null) {
        existing.isEarned = true;
        existing.earnedAt = DateTime.now();
        await _hiveDataSource.saveBadge(existing);
      } else {
        // Create new badge record
        final badge = BadgeHiveModel(
          id: badgeId,
          name: badgeId,
          iconPath: 'assets/images/badges/$badgeId.png',
          unlockCondition: '',
          isEarned: true,
          earnedAt: DateTime.now(),
        );
        await _hiveDataSource.saveBadge(badge);
      }
      return const Right(unit);
    } catch (e, st) {
      _logger.e('AwardBadge failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }
}
