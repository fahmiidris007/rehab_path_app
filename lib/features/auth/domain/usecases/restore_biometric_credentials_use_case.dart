import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/biometric_credential_repository.dart';

class RestoreBiometricCredentialsParams extends Equatable {
  final String reason;

  const RestoreBiometricCredentialsParams({required this.reason});

  @override
  List<Object?> get props => [reason];
}

/// Triggers the OS biometric prompt and, on success, returns the stored
/// credential pair so `AuthCubit` can replay the standard login flow.
///
/// Flow:
///   1. Invoke [BiometricCredentialRepository.authenticate] with the
///      localized reason string.
///   2. If authentication produced a [Failure], propagate it unchanged.
///   3. If the prompt completed but did not authenticate the user
///      (`Right(false)`), surface an unexpected failure tagged
///      `authBiometricFailed` so the UI can show the localized error.
///   4. Otherwise, read the stored credentials from secure storage and
///      return them as a Dart 3 record.
///
/// Validates: Requirements 3.2, 3.3, 3.5.
@injectable
class RestoreBiometricCredentialsUseCase
    extends UseCase<({String phoneNumber, String password}),
        RestoreBiometricCredentialsParams> {
  final BiometricCredentialRepository _repository;

  RestoreBiometricCredentialsUseCase(this._repository);

  @override
  Future<Either<Failure, ({String phoneNumber, String password})>> call(
    RestoreBiometricCredentialsParams params,
  ) async {
    final auth = await _repository.authenticate(reason: params.reason);
    if (auth.isLeft()) {
      final failure = auth.swap().getOrElse(
            () => const Failure.unexpected(message: 'authBiometricFailed'),
          );
      return Left(failure);
    }
    final authenticated = auth.getOrElse(() => false);
    if (!authenticated) {
      return const Left(
        Failure.unexpected(message: 'authBiometricFailed'),
      );
    }
    return _repository.readCredentials();
  }
}
