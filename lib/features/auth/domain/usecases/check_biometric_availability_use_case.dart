import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/biometric_credential_repository.dart';

/// Reports the combined hardware + user-preference biometric availability.
///
/// Thin wrapper over [BiometricCredentialRepository.getStatus]. Never
/// triggers an OS biometric prompt — this is a capability check used by
/// `AuthCubit.requestBiometricLogin` to decide whether to show the prompt
/// or surface an unavailable/disabled state.
///
/// Validates: Requirements 3.2, 3.3, 3.4.
@injectable
class CheckBiometricAvailabilityUseCase
    extends UseCase<BiometricStatus, NoParams> {
  final BiometricCredentialRepository _repository;

  CheckBiometricAvailabilityUseCase(this._repository);

  @override
  Future<Either<Failure, BiometricStatus>> call(NoParams params) =>
      _repository.getStatus();
}
