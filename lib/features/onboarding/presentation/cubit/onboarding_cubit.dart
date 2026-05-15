import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/use_case.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../../domain/usecases/compute_program_level_use_case.dart';
import '../../domain/usecases/get_partial_onboarding_use_case.dart';
import '../../domain/usecases/save_onboarding_profile_use_case.dart';
import 'onboarding_state.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  final SaveOnboardingProfileUseCase _saveProfileUseCase;
  final GetPartialOnboardingUseCase _getPartialUseCase;
  final ComputeProgramLevelUseCase _computeLevelUseCase;

  OnboardingCubit(
    this._saveProfileUseCase,
    this._getPartialUseCase,
    this._computeLevelUseCase,
  ) : super(const OnboardingState());

  Future<void> loadPartialProfile() async {
    final result = await _getPartialUseCase(const NoParams());
    result.fold(
      (failure) => null, // silently ignore
      (profile) {
        if (profile != null) {
          emit(state.copyWith(
            partialProfile: profile,
            currentStep: (profile.lastCompletedStep ?? 0) + 1,
          ));
        }
      },
    );
  }

  Future<void> nextStep(OnboardingProfileEntity updatedProfile) async {
    if (state.currentStep >= 7) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));

    // Save partial progress
    final profileWithStep = updatedProfile.copyWith(
      lastCompletedStep: state.currentStep,
    );
    await _saveProfileUseCase(profileWithStep);

    emit(state.copyWith(
      isLoading: false,
      currentStep: state.currentStep + 1,
      partialProfile: profileWithStep,
    ));
  }

  void previousStep() {
    if (state.currentStep <= 1) return;
    emit(state.copyWith(currentStep: state.currentStep - 1));
  }

  Future<void> submitOnboarding(OnboardingProfileEntity finalProfile) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    // Compute program level
    final levelResult = await _computeLevelUseCase(finalProfile);
    final level = levelResult.getOrElse(() => ProgramLevel.beginner);

    // Save complete profile
    final completeProfile = finalProfile.copyWith(
      programLevel: level,
      lastCompletedStep: 7,
    );
    final saveResult = await _saveProfileUseCase(completeProfile);

    saveResult.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.when(
          server: (msg, _) => msg,
          cache: (msg) => msg,
          validation: (msg, _) => msg,
          unexpected: (msg) => msg,
        ),
      )),
      (_) => emit(state.copyWith(
        isLoading: false,
        isComplete: true,
        computedLevel: level,
        partialProfile: completeProfile,
      )),
    );
  }

  void clearError() => emit(state.copyWith(errorMessage: null));
}
