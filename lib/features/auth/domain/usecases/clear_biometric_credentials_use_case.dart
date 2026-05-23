import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/biometric_credential_repository.dart';

/// Removes stored biometric credentials and disables biometric login.
///
/// Thin wrapper over [BiometricCredentialRepository.clearCredentials].
/// Never triggers an OS biometric prompt (R4.6) — this is a destructive,
/// prompt-free operation invoked from Settings or after a
/// `biometric_session_expired` recovery (R3.7).
///
/// Validates: Requirements 4.6.
@injectable
class ClearBiometricCredentialsUseCase extends UseCase<Unit, NoParams> {
  final BiometricCredentialRepository _repository;

  ClearBiometricCredentialsUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) =>
      _repository.clearCredentials();
}
