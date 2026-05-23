import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/biometric_credential_repository.dart';

class StoreBiometricCredentialsParams extends Equatable {
  final String phoneNumber;
  final String password;

  const StoreBiometricCredentialsParams({
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [phoneNumber, password];
}

/// Persists the credentials used to auto-fill the login form after a
/// successful biometric prompt.
///
/// Delegates to [BiometricCredentialRepository.storeCredentials], which
/// writes to secure storage under distinct keys per R4.4.
///
/// Validates: Requirements 4.4.
@injectable
class StoreBiometricCredentialsUseCase
    extends UseCase<Unit, StoreBiometricCredentialsParams> {
  final BiometricCredentialRepository _repository;

  StoreBiometricCredentialsUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(StoreBiometricCredentialsParams params) =>
      _repository.storeCredentials(
        phoneNumber: params.phoneNumber,
        password: params.password,
      );
}
