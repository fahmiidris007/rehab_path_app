import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/progress_repository.dart';

/// Returns the current consecutive-day exercise streak for the given user.
///
/// The streak is computed by fetching sessions for the current month and the
/// previous month (to handle month boundaries), then counting how many
/// consecutive calendar days ending on today have at least one completed
/// session.
@injectable
class GetStreakUseCase extends UseCase<int, String> {
  final ProgressRepository _repository;

  GetStreakUseCase(this._repository);

  @override
  Future<Either<Failure, int>> call(String userId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Fetch sessions for the current month and the previous month so we can
    // handle streaks that span a month boundary.
    final currentMonthResult =
        await _repository.getSessionsForMonth(DateTime(now.year, now.month));
    if (currentMonthResult.isLeft()) return currentMonthResult.map((_) => 0);

    final prevMonth = DateTime(now.year, now.month - 1);
    final prevMonthResult = await _repository.getSessionsForMonth(prevMonth);
    if (prevMonthResult.isLeft()) return prevMonthResult.map((_) => 0);

    final allSessions = [
      ...currentMonthResult.getOrElse(() => []),
      ...prevMonthResult.getOrElse(() => []),
    ];

    // Collect the unique calendar days that have at least one session.
    final activeDays = <DateTime>{};
    for (final session in allSessions) {
      final d = session.completedAt;
      activeDays.add(DateTime(d.year, d.month, d.day));
    }

    // Walk backwards from today counting consecutive active days.
    int streak = 0;
    DateTime cursor = today;
    while (activeDays.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return Right(streak);
  }
}
