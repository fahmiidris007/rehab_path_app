import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../exercise/domain/repositories/exercise_repository.dart';

class GetTodayScheduleParams extends Equatable {
  final String userId;

  const GetTodayScheduleParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Returns the list of [ExerciseEntity] scheduled for today
/// based on the user's assigned [ProgramEntity] day-of-week mapping.
@injectable
class GetTodayScheduleUseCase
    extends UseCase<List<ExerciseEntity>, GetTodayScheduleParams> {
  final ExerciseRepository _repository;

  GetTodayScheduleUseCase(this._repository);

  @override
  Future<Either<Failure, List<ExerciseEntity>>> call(
    GetTodayScheduleParams params,
  ) =>
      _repository.getTodaySchedule(params.userId);
}
