import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../repositories/onboarding_repository.dart';

@lazySingleton
class SaveOnboardingProfileUseCase
    implements UseCase<Unit, OnboardingProfileEntity> {
  const SaveOnboardingProfileUseCase(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(OnboardingProfileEntity params) {
    return _repository.saveProfile(params);
  }
}
