import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../repositories/exercise_repository.dart';

@lazySingleton
class GetExerciseByIdUseCase
    implements UseCase<ExerciseEntity, GetExerciseByIdParams> {
  const GetExerciseByIdUseCase(this._repository);

  final ExerciseRepository _repository;

  @override
  Future<Either<Failure, ExerciseEntity>> call(GetExerciseByIdParams params) {
    return _repository.getExerciseById(params.id);
  }
}

class GetExerciseByIdParams extends Equatable {
  const GetExerciseByIdParams(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
