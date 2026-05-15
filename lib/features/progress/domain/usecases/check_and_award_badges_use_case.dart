import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/badge_entity.dart';
import '../repositories/progress_repository.dart';
import 'get_streak_use_case.dart';

/// Badge IDs used by the award logic.
class BadgeIds {
  static const String firstSession = 'first_session';
  static const String sevenDayStreak = '7_day_streak';
  static const String thirtySessionsMilestone = '30_sessions';
}

/// Checks whether the user has met the criteria for any unearned badges and
/// awards them.  Returns the list of newly awarded [BadgeEntity] entries.
///
/// Criteria:
/// - **First Session** (`first_session`): total completed sessions == 1.
/// - **7-Day Streak** (`7_day_streak`): current streak >= 7.
/// - **30 Sessions** (`30_sessions`): total completed sessions >= 30.
@injectable
class CheckAndAwardBadgesUseCase extends UseCase<List<BadgeEntity>, String> {
  final ProgressRepository _repository;
  final GetStreakUseCase _getStreakUseCase;

  CheckAndAwardBadgesUseCase(this._repository, this._getStreakUseCase);

  @override
  Future<Either<Failure, List<BadgeEntity>>> call(String userId) async {
    // 1. Fetch current badges.
    final badgesResult = await _repository.getBadges(userId);
    if (badgesResult.isLeft()) {
      return badgesResult.map((_) => <BadgeEntity>[]);
    }
    final badges = badgesResult.getOrElse(() => []);

    // 2. Fetch all sessions for the current month to count total sessions.
    //    We also need a broader count, so we fetch the last 12 months.
    final now = DateTime.now();
    int totalSessions = 0;
    for (int i = 0; i < 12; i++) {
      final month = DateTime(now.year, now.month - i);
      final result = await _repository.getSessionsForMonth(month);
      result.fold(
        (_) {},
        (sessions) => totalSessions += sessions.length,
      );
    }

    // 3. Fetch current streak.
    final streakResult = await _getStreakUseCase(userId);
    if (streakResult.isLeft()) {
      return streakResult.map((_) => <BadgeEntity>[]);
    }
    final streak = streakResult.getOrElse(() => 0);

    // 4. Determine which badges should be awarded.
    final unearnedBadgeIds = badges
        .where((b) => !b.isEarned)
        .map((b) => b.id)
        .toSet();

    final toAward = <String>[];

    if (unearnedBadgeIds.contains(BadgeIds.firstSession) &&
        totalSessions == 1) {
      toAward.add(BadgeIds.firstSession);
    }
    if (unearnedBadgeIds.contains(BadgeIds.sevenDayStreak) && streak >= 7) {
      toAward.add(BadgeIds.sevenDayStreak);
    }
    if (unearnedBadgeIds.contains(BadgeIds.thirtySessionsMilestone) &&
        totalSessions >= 30) {
      toAward.add(BadgeIds.thirtySessionsMilestone);
    }

    // 5. Award each qualifying badge and collect the updated entities.
    final newlyAwarded = <BadgeEntity>[];
    for (final badgeId in toAward) {
      final awardResult = await _repository.awardBadge(userId, badgeId);
      if (awardResult.isLeft()) {
        return awardResult.map((_) => <BadgeEntity>[]);
      }
      // Find the badge entity and mark it as earned locally for the return value.
      final badge = badges.firstWhere((b) => b.id == badgeId);
      newlyAwarded.add(badge.copyWith(isEarned: true, earnedAt: now));
    }

    return Right(newlyAwarded);
  }
}
