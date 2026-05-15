import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../repositories/exercise_repository.dart';

@lazySingleton
class GetExercisesByLevelUseCase
    implements UseCase<List<ExerciseEntity>, GetExercisesByLevelParams> {
  const GetExercisesByLevelUseCase(this._repository);

  final ExerciseRepository _repository;

  @override
  Future<Either<Failure, List<ExerciseEntity>>> call(
    GetExercisesByLevelParams params,
  ) {
    return _repository.getExercisesByLevel(params.level);
  }
}

class GetExercisesByLevelParams extends Equatable {
  const GetExercisesByLevelParams(this.level);

  final ProgramLevel level;

  @override
  List<Object?> get props => [level];
}
