import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../exercise/domain/repositories/exercise_repository.dart';

class GetTodayScheduleParams extends Equatable {
  final String userId;

  const GetTodayScheduleParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Returns the list of [ExerciseEntity] scheduled for today by delegating to
/// [ExerciseRepository.getScheduleForDate] with `AppDateUtils.todayLocal()`,
/// ensuring the same deterministic schedule is used everywhere.
@injectable
class GetTodayScheduleUseCase
    extends UseCase<List<ExerciseEntity>, GetTodayScheduleParams> {
  final ExerciseRepository _repository;

  GetTodayScheduleUseCase(this._repository);

  @override
  Future<Either<Failure, List<ExerciseEntity>>> call(
    GetTodayScheduleParams params,
  ) =>
      _repository.getScheduleForDate(
        userId: params.userId,
        date: AppDateUtils.todayLocal(),
      );
}
