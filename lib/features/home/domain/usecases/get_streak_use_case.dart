import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../progress/domain/repositories/progress_repository.dart';

class GetStreakParams extends Equatable {
  final String userId;

  const GetStreakParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Computes the current consecutive-day exercise streak for [userId]
/// by inspecting completed [ExerciseSessionEntity] history from Hive.
@injectable
class GetStreakUseCase extends UseCase<int, GetStreakParams> {
  final ProgressRepository _repository;

  GetStreakUseCase(this._repository);

  @override
  Future<Either<Failure, int>> call(GetStreakParams params) async {
    final today = DateTime.now();
    // Look back up to 365 days to compute streak
    final monthResult = await _repository.getSessionsForMonth(today);

    return monthResult.fold(
      (failure) => Left(failure),
      (sessions) {
        if (sessions.isEmpty) return const Right(0);

        // Collect unique dates with completed sessions
        final completedDates = sessions
            .map((s) {
              final d = s.completedAt;
              return DateTime(d.year, d.month, d.day);
            })
            .toSet();

        int streak = 0;
        var checkDate = DateTime(today.year, today.month, today.day);

        while (completedDates.contains(checkDate)) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        }

        return Right(streak);
      },
    );
  }
}
