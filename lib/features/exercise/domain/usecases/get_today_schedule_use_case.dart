import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../repositories/exercise_repository.dart';

@lazySingleton
class GetTodayScheduleUseCase
    implements UseCase<List<ExerciseEntity>, GetTodayScheduleParams> {
  const GetTodayScheduleUseCase(this._repository);

  final ExerciseRepository _repository;

  @override
  Future<Either<Failure, List<ExerciseEntity>>> call(
    GetTodayScheduleParams params,
  ) {
    return _repository.getScheduleForDate(
      userId: params.userId,
      date: AppDateUtils.todayLocal(),
    );
  }
}

class GetTodayScheduleParams extends Equatable {
  const GetTodayScheduleParams(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}
