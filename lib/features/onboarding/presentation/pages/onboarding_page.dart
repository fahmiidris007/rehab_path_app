import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_outline_button.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../di/injection.dart';
import '../../../../shared/domain/entities/onboarding_profile_entity.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/step1_age_gender_widget.dart';
import '../widgets/step2_falls_widget.dart';
import '../widgets/step3_conditions_widget.dart';
import '../widgets/step4_walking_aid_widget.dart';
import '../widgets/step5_fear_widget.dart';
import '../widgets/step6_preferences_widget.dart';
import '../widgets/step7_goals_widget.dart';

/// Entry point for the onboarding flow.
///
/// Provides [OnboardingCubit] and loads any partial profile saved from a
/// previous session before rendering the step view.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (_) => getIt<OnboardingCubit>()..loadPartialProfile(),
      child: const _OnboardingView(),
    );
  }
}

// ── Internal view ─────────────────────────────────────────────────────────────

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  static const int _totalSteps = 7;

  late final PageController _pageController;

  // Keys for each step widget so we can call validate() on them.
  final _step1Key = GlobalKey<Step1AgeGenderWidgetState>();
  final _step2Key = GlobalKey<Step2FallsWidgetState>();
  final _step6Key = GlobalKey<Step6PreferencesWidgetState>();
  final _step7Key = GlobalKey<Step7GoalsWidgetState>();

  // Local copy of the profile being built up across steps.
  OnboardingProfileEntity? _pendingProfile;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _onDataChanged(OnboardingProfileEntity profile) {
    _pendingProfile = profile;
  }

  bool _validateCurrentStep(int step) {
    switch (step) {
      case 1:
        return _step1Key.currentState?.validate() ?? false;
      case 2:
        return _step2Key.currentState?.validate() ?? false;
      case 3:
        // Conditions are optional — always valid.
        return true;
      case 4:
        // Walking aid must be selected.
        return _pendingProfile?.usesWalkingAid != null ||
            context.read<OnboardingCubit>().state.partialProfile?.usesWalkingAid !=
                null;
      case 5:
        // Fear score must be 1–5.
        final score = _pendingProfile?.fearOfFallingScore ??
            context.read<OnboardingCubit>().state.partialProfile?.fearOfFallingScore ??
            0;
        return score >= 1 && score <= 5;
      case 6:
        return _step6Key.currentState?.validate() ?? false;
      case 7:
        return _step7Key.currentState?.validate() ?? false;
      default:
        return true;
    }
  }

  Future<void> _onContinue(OnboardingState state) async {
    final cubit = context.read<OnboardingCubit>();
    final currentStep = state.currentStep;

    // Merge pending changes with the existing partial profile so we always
    // have a complete entity to pass to the cubit.
    final profile = _pendingProfile ?? state.partialProfile;

    if (profile == null) {
      // Nothing collected yet — show validation errors.
      _validateCurrentStep(currentStep);
      return;
    }

    if (!_validateCurrentStep(currentStep)) return;

    if (currentStep == _totalSteps) {
      await cubit.submitOnboarding(profile);
    } else {
      await cubit.nextStep(profile);
      // Animate to the next page after the state update.
      if (mounted) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _onBack(OnboardingState state) {
    context.read<OnboardingCubit>().previousStep();
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listenWhen: (prev, curr) => curr.isComplete && !prev.isComplete,
      listener: (context, state) {
        if (state.isComplete) {
          context.go('/home');
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // ── Step indicator ───────────────────────────────────────
                _StepIndicator(
                  currentStep: state.currentStep,
                  totalSteps: _totalSteps,
                ),

                // ── Page content ─────────────────────────────────────────
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _StepPage(
                        child: Step1AgeGenderWidget(
                          key: _step1Key,
                          profile: state.partialProfile,
                          onDataChanged: _onDataChanged,
                        ),
                      ),
                      _StepPage(
                        child: Step2FallsWidget(
                          key: _step2Key,
                          profile: state.partialProfile,
                          onDataChanged: _onDataChanged,
                        ),
                      ),
                      _StepPage(
                        child: Step3ConditionsWidget(
                          profile: state.partialProfile,
                          onDataChanged: _onDataChanged,
                        ),
                      ),
                      _StepPage(
                        child: Step4WalkingAidWidget(
                          profile: state.partialProfile,
                          onDataChanged: _onDataChanged,
                        ),
                      ),
                      _StepPage(
                        child: Step5FearWidget(
                          profile: state.partialProfile,
                          onDataChanged: _onDataChanged,
                        ),
                      ),
                      _StepPage(
                        child: Step6PreferencesWidget(
                          key: _step6Key,
                          profile: state.partialProfile,
                          onDataChanged: _onDataChanged,
                        ),
                      ),
                      _StepPage(
                        child: Step7GoalsWidget(
                          key: _step7Key,
                          profile: state.partialProfile,
                          onDataChanged: _onDataChanged,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Navigation buttons ───────────────────────────────────
                _NavigationButtons(
                  currentStep: state.currentStep,
                  totalSteps: _totalSteps,
                  isLoading: state.isLoading,
                  onBack: () => _onBack(state),
                  onContinue: () => _onContinue(state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Step indicator ────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenPaddingH,
        24,
        AppDimensions.screenPaddingH,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step $currentStep of $totalSteps',
            style: AppTextStyles.bodySemiBold.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: AppDimensions.progressBarH,
              backgroundColor: AppColors.neutralGray,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Navigation buttons ────────────────────────────────────────────────────────

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons({
    required this.currentStep,
    required this.totalSteps,
    required this.isLoading,
    required this.onBack,
    required this.onContinue,
  });

  final int currentStep;
  final int totalSteps;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == totalSteps;
    final showBack = currentStep > 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenPaddingH,
        8,
        AppDimensions.screenPaddingH,
        24,
      ),
      child: Row(
        children: [
          if (showBack) ...[
            Expanded(
              child: AppOutlineButton(
                label: 'Back',
                onPressed: isLoading ? null : onBack,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: showBack ? 2 : 1,
            child: AppPrimaryButton(
              label: isLastStep ? 'Finish' : 'Continue',
              isLoading: isLoading,
              onPressed: isLoading ? null : onContinue,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step page wrapper ─────────────────────────────────────────────────────────

class _StepPage extends StatelessWidget {
  const _StepPage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
        vertical: 8,
      ),
      child: child,
    );
  }
}
