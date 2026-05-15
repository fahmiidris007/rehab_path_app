import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../core/constants/pref_keys.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/data/datasources/hive_data_source.dart';
import '../../../../shared/data/datasources/shared_preferences_data_source.dart';
import '../../../../shared/data/models/onboarding_profile_hive_model.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/usecases/compute_program_level_use_case.dart';

@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  final HiveDataSource _hiveDataSource;
  final SharedPreferencesDataSource _prefsDataSource;
  final Logger _logger;

  OnboardingRepositoryImpl(
    this._hiveDataSource,
    this._prefsDataSource,
    this._logger,
  );

  // Use a fixed key for the partial onboarding profile (current user's profile)
  static const String _partialProfileKey = 'current_user_onboarding';

  @override
  Future<Either<Failure, Unit>> saveProfile(
    OnboardingProfileEntity profile,
  ) async {
    try {
      final userId =
          _prefsDataSource.getString(PrefKeys.sessionUserId) ??
          _partialProfileKey;
      await _hiveDataSource.saveOnboardingProfile(
        userId,
        OnboardingProfileHiveModel.fromEntity(profile),
      );
      // If lastCompletedStep == 7, mark onboarding as complete
      if (profile.lastCompletedStep == 7) {
        await _prefsDataSource.setBool(PrefKeys.onboardingComplete, true);
        // Also update the user's programLevel in userBox
        final user = _hiveDataSource.getUser(userId);
        if (user != null) {
          user.programLevel = profile.programLevel.name;
          user.age = profile.age;
          user.gender = profile.gender;
          user.healthConditions = profile.healthConditions;
          await _hiveDataSource.saveUser(user);
        }
      }
      return const Right(unit);
    } catch (e, st) {
      _logger.e('saveProfile failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OnboardingProfileEntity?>> getPartialProfile() async {
    try {
      final userId =
          _prefsDataSource.getString(PrefKeys.sessionUserId) ??
          _partialProfileKey;
      final model = _hiveDataSource.getOnboardingProfile(userId);
      return Right(model?.toEntity());
    } catch (e, st) {
      _logger.e('getPartialProfile failed', error: e, stackTrace: st);
      return Left(Failure.cache(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProgramLevel>> computeProgramLevel(
    OnboardingProfileEntity profile,
  ) async {
    return Right(ComputeProgramLevelUseCase.compute(profile));
  }
}
