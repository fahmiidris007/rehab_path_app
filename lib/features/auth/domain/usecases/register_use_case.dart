import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

@injectable
class RegisterUseCase extends UseCase<UserEntity, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) =>
      _repository.register(params.name, params.email, params.password);
}
