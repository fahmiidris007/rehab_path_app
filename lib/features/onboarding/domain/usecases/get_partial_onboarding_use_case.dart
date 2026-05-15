import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../repositories/onboarding_repository.dart';

@lazySingleton
class GetPartialOnboardingUseCase
    implements UseCase<OnboardingProfileEntity?, NoParams> {
  const GetPartialOnboardingUseCase(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, OnboardingProfileEntity?>> call(NoParams params) {
    return _repository.getPartialProfile();
  }
}
