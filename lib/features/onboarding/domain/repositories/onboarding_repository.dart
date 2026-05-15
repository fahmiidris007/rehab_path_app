import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, Unit>> saveProfile(OnboardingProfileEntity profile);
  Future<Either<Failure, OnboardingProfileEntity?>> getPartialProfile();
  Future<Either<Failure, ProgramLevel>> computeProgramLevel(
    OnboardingProfileEntity profile,
  );
}
