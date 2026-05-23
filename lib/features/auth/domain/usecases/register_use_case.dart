import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  final String name;
  final String phoneNumber;
  final String password;

  const RegisterParams({
    required this.name,
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [name, phoneNumber, password];
}

@injectable
class RegisterUseCase extends UseCase<UserEntity, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) =>
      _repository.register(
        name: params.name,
        phoneNumber: params.phoneNumber,
        password: params.password,
      );
}
