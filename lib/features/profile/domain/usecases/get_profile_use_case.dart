import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileParams extends Equatable {
  final String userId;

  const GetProfileParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

@injectable
class GetProfileUseCase extends UseCase<UserEntity, GetProfileParams> {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(GetProfileParams params) =>
      _repository.getProfile(params.userId);
}
