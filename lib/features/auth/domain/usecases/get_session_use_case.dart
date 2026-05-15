import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class GetSessionUseCase extends UseCase<UserEntity?, NoParams> {
  final AuthRepository _repository;

  GetSessionUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) =>
      _repository.getSession();
}
