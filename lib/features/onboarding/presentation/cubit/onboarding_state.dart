import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(1) int currentStep,
    OnboardingProfileEntity? partialProfile,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(false) bool isComplete,
    ProgramLevel? computedLevel,
  }) = _OnboardingState;
}
