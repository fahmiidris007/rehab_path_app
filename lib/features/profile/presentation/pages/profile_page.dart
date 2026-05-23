import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/app_emergency_button.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_top_app_bar.dart';
import '../../../../di/injection.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../features/auth/presentation/cubit/auth_state.dart';
import '../../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppTopAppBar(title: l10n.profileTitle),
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

  String _programLevelLabel(ProgramLevel level, AppLocalizations l10n) {
    return switch (level) {
      ProgramLevel.beginner => l10n.profileProgramLevelBeginner,
      ProgramLevel.intermediate => l10n.profileProgramLevelIntermediate,
      ProgramLevel.advanced => l10n.profileProgramLevelAdvanced,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onboarding = user.onboardingProfile;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),

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
          const SizedBox(height: 12),

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
            l10n.profileYearsOld(user.age),
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),

          // ── Program level chip ───────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            ),
            child: Text(
              _programLevelLabel(user.programLevel, l10n),
              style: AppTextStyles.label.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),

          // ── Health conditions ────────────────────────────────────────────
          if (user.healthConditions.isNotEmpty) ...[
            _SectionHeader(title: l10n.profileHealthConditions),
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
            _SectionHeader(title: l10n.profileGoals),
            const SizedBox(height: 12),
            _GoalTile(
              label: l10n.profileOutcomeGoal,
              value: onboarding.outcomeGoal,
            ),
            const SizedBox(height: 8),
            _GoalTile(
              label: l10n.profileBehaviouralGoal,
              value: onboarding.behaviouralGoal,
            ),
            const SizedBox(height: AppDimensions.sectionGap),
          ],

          // ── Actions ──────────────────────────────────────────────────────
          _SolidButton(
            label: l10n.profileEmergencyContacts,
            color: AppColors.primary,
            onTap: () => context.pushNamed('sos'),
          ),
          const SizedBox(height: 12),
          _SolidButton(
            label: l10n.settingsTitle,
            color: AppColors.primary,
            onTap: () => context.pushNamed(RouteNames.settings),
          ),
          const SizedBox(height: 12),
          _SolidButton(
            label: l10n.profileLogOut,
            color: AppColors.error,
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.profileLogOutConfirmTitle),
                  content: Text(l10n.profileLogOutConfirmMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text(l10n.profileLogOutConfirmCancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                      child: Text(l10n.profileLogOutConfirmButton),
                    ),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                context.read<AuthCubit>().logout();
              }
            },
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
      alignment: Alignment.center,
      child: Text(
        title,
        style: AppTextStyles.h3Section.copyWith(color: AppColors.textPrimary),
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
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

/// A full-width solid action button matching the style of [AppEmergencyButton].
class _SolidButton extends StatelessWidget {
  const _SolidButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: AppDimensions.recTouchTarget,
        minHeight: AppDimensions.recTouchTarget,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SizedBox(
          height: AppDimensions.primaryButtonH,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: Text(
                    label,
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
