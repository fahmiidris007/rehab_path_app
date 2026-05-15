import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_emergency_button.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_outline_button.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_top_app_bar.dart';
import '../../../../di/injection.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../features/auth/presentation/cubit/auth_state.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../cubit/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<ProfileCubit>();
        final authState = context.read<AuthCubit>().state;
        if (authState is AuthAuthenticated) {
          cubit.loadProfile(authState.user.id);
        }
        return cubit;
      },
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopAppBar(title: 'Profile'),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return switch (state) {
            ProfileLoading() => const AppLoadingWidget(),
            ProfileError(:final message) => AppErrorWidget(message: message),
            ProfileLoaded(:final user) => _ProfileContent(user: user),
          };
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.user});

  final UserEntity user;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  String _programLevelLabel(ProgramLevel level) {
    return switch (level) {
      ProgramLevel.beginner => 'Beginner',
      ProgramLevel.intermediate => 'Intermediate',
      ProgramLevel.advanced => 'Advanced',
    };
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = user.onboardingProfile;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
        vertical: AppDimensions.sectionGap,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Avatar ──────────────────────────────────────────────────────
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              _initials(user.name),
              style: AppTextStyles.displayH1.copyWith(
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Full name ────────────────────────────────────────────────────
          Text(
            user.name,
            style: AppTextStyles.displayH1.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // ── Age ──────────────────────────────────────────────────────────
          Text(
            '${user.age} years old',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // ── Program level chip ───────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            ),
            child: Text(
              _programLevelLabel(user.programLevel),
              style: AppTextStyles.label.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.sectionGap),

          // ── Health conditions ────────────────────────────────────────────
          if (user.healthConditions.isNotEmpty) ...[
            _SectionHeader(title: 'Health Conditions'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: user.healthConditions
                  .map((c) => _ConditionChip(label: c))
                  .toList(),
            ),
            const SizedBox(height: AppDimensions.sectionGap),
          ],

          // ── Goals ────────────────────────────────────────────────────────
          if (onboarding != null) ...[
            _SectionHeader(title: 'Goals'),
            const SizedBox(height: 12),
            _GoalTile(
              label: 'Outcome Goal',
              value: onboarding.outcomeGoal,
            ),
            const SizedBox(height: 8),
            _GoalTile(
              label: 'Behavioural Goal',
              value: onboarding.behaviouralGoal,
            ),
            const SizedBox(height: AppDimensions.sectionGap),
          ],

          // ── Actions ──────────────────────────────────────────────────────
          AppPrimaryButton(
            label: 'Edit Profile',
            onPressed: () => context.pushNamed('edit-profile'),
          ),
          const SizedBox(height: 12),
          AppOutlineButton(
            label: 'Update Goals',
            onPressed: () => context.go('/onboarding/7'),
          ),
          const SizedBox(height: 12),
          AppEmergencyButton(
            label: 'Emergency Contacts',
            onPressed: () => context.pushNamed('sos'),
          ),
          const SizedBox(height: AppDimensions.sectionGap),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: AppTextStyles.h3Section.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _ConditionChip extends StatelessWidget {
  const _ConditionChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.blueLightBorder,
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: AppColors.primary,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySemiBold.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
