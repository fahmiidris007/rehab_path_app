import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../repositories/exercise_repository.dart';

@lazySingleton
class GetAllExercisesUseCase implements UseCase<List<ExerciseEntity>, NoParams> {
  const GetAllExercisesUseCase(this._repository);

  final ExerciseRepository _repository;

  @override
  Future<Either<Failure, List<ExerciseEntity>>> call(NoParams params) {
    return _repository.getAllExercises();
  }
}
