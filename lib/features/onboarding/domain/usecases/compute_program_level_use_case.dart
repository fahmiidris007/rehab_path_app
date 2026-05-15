import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../repositories/onboarding_repository.dart';

@lazySingleton
class ComputeProgramLevelUseCase
    implements UseCase<ProgramLevel, OnboardingProfileEntity> {
  const ComputeProgramLevelUseCase(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, ProgramLevel>> call(OnboardingProfileEntity params) {
    return _repository.computeProgramLevel(params);
  }

  /// Pure computation of [ProgramLevel] from a given [OnboardingProfileEntity].
  ///
  /// Rules (evaluated in order):
  /// 1. **Beginner** — age ≥ 70, OR falls in last year ≥ 2, OR fear-of-falling
  ///    score ≥ 4.
  /// 2. **Advanced** — age < 65, AND falls in last year == 0, AND
  ///    fear-of-falling score ≤ 2.
  /// 3. **Intermediate** — all other cases.
  static ProgramLevel compute(OnboardingProfileEntity profile) {
    if (profile.age >= 70 ||
        profile.fallsInLastYear >= 2 ||
        profile.fearOfFallingScore >= 4) {
      return ProgramLevel.beginner;
    }
    if (profile.age < 65 &&
        profile.fallsInLastYear == 0 &&
        profile.fearOfFallingScore <= 2) {
      return ProgramLevel.advanced;
    }
    return ProgramLevel.intermediate;
  }
}
