import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../repositories/profile_repository.dart';

@injectable
class UpdateProfileUseCase extends UseCase<Unit, UserEntity> {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(UserEntity params) =>
      _repository.updateProfile(params);
}
