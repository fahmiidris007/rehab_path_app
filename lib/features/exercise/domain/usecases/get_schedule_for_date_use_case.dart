import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../repositories/exercise_repository.dart';

/// Parameters for [GetScheduleForDateUseCase].
///
/// `date` is normalized to local midnight by the repository before lookup, so
/// any time-of-day component on the same calendar day yields the same result.
class GetScheduleForDateParams extends Equatable {
  final String userId;
  final DateTime date;

  const GetScheduleForDateParams({
    required this.userId,
    required this.date,
  });

  @override
  List<Object?> get props => [userId, date];
}

/// Returns the deterministic exercise schedule for `(userId, date)` by
/// delegating to [ExerciseRepository.getScheduleForDate].
@injectable
class GetScheduleForDateUseCase
    extends UseCase<List<ExerciseEntity>, GetScheduleForDateParams> {
  final ExerciseRepository _repository;

  GetScheduleForDateUseCase(this._repository);

  @override
  Future<Either<Failure, List<ExerciseEntity>>> call(
    GetScheduleForDateParams params,
  ) =>
      _repository.getScheduleForDate(
        userId: params.userId,
        date: params.date,
      );
}
