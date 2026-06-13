import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/widgets/app_outline_button.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/zero_state_widget.dart';
import '../../../../di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/exercise_list_cubit.dart';
import '../cubit/exercise_list_state.dart';
import '../widgets/exercise_card.dart';

/// Displays the fixed exercise schedule in order:
/// 1. Pemanasan (Warm Up)
/// 2. Latihan Keseimbangan (Balance Training)
/// 3. Latihan Kekuatan (Strength Training)
/// 4. Pendinginan (Cool Down)
///
/// Also offers a toggle to view all exercises from the catalogue.
///
/// Provides its own [ExerciseListCubit] via [BlocProvider]. The active user
/// id is resolved from [AuthCubit]; guests fall back to an empty id so the
/// today schedule degrades gracefully to an empty state.
class ExerciseListPage extends StatelessWidget {
  const ExerciseListPage({super.key});

  String _resolveUserId(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final userId = _resolveUserId(context);
    return BlocProvider<ExerciseListCubit>(
      create: (_) => getIt<ExerciseListCubit>()..loadInitial(userId),
      child: _ExerciseListView(userId: userId),
    );
  }
}

class _ExerciseListView extends StatelessWidget {
  const _ExerciseListView({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<ExerciseListCubit, ExerciseListState>(
          builder: (context, state) {
            final cubit = context.read<ExerciseListCubit>();
            return switch (state) {
              ExerciseListLoading() => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              ExerciseListError(:final message) => ZeroStateWidget(
                icon: const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 64,
                ),
                title: l10n.exerciseSomethingWentWrong,
                subtitle: message,
                action: AppPrimaryButton(
                  label: l10n.commonRetry,
                  onPressed: () => cubit.loadInitial(userId),
                ),
              ),
              ExerciseListTodayMode(:final todaySchedule) => _TodayModeView(
                exercises: todaySchedule,
                onSwitchToAllMode: cubit.switchToAllMode,
              ),
              ExerciseListAllMode(:final allExercises) => _AllModeView(
                exercises: allExercises,
                onBackToToday: () => cubit.switchToTodayMode(userId),
              ),
            };
          },
        ),
      ),
    );
  }
}

// ── Today mode view ───────────────────────────────────────────────────────────

class _TodayModeView extends StatelessWidget {
  const _TodayModeView({
    required this.exercises,
    required this.onSwitchToAllMode,
  });

  final List<ExerciseEntity> exercises;
  final VoidCallback onSwitchToAllMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (exercises.isEmpty) {
      return ZeroStateWidget(
        icon: const Icon(
          Icons.event_available_outlined,
          color: AppColors.textDisabled,
          size: 64,
        ),
        title: l10n.exerciseListNoneToday,
        action: AppPrimaryButton(
          label: l10n.exerciseListAllExercises,
          onPressed: onSwitchToAllMode,
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(l10n.exerciseListTitle),
          floating: true,
          snap: true,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingH,
            vertical: 8,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final exercise = exercises[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.cardGap),
                child: ExerciseCard(
                  exercise: exercise,
                  orderNumber: index + 1,
                  onTap: () => context.pushNamed(
                    RouteNames.exerciseDetail,
                    pathParameters: {'id': exercise.id},
                  ),
                ),
              );
            }, childCount: exercises.length),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.screenPaddingH,
            8,
            AppDimensions.screenPaddingH,
            24,
          ),
          sliver: SliverToBoxAdapter(
            child: AppOutlineButton(
              label: l10n.exerciseListAllExercises,
              onPressed: onSwitchToAllMode,
            ),
          ),
        ),
      ],
    );
  }
}

// ── All mode view ─────────────────────────────────────────────────────────────

class _AllModeView extends StatelessWidget {
  const _AllModeView({required this.exercises, required this.onBackToToday});

  final List<ExerciseEntity> exercises;
  final VoidCallback onBackToToday;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (exercises.isEmpty) {
      return ZeroStateWidget(
        icon: const Icon(
          Icons.fitness_center,
          color: AppColors.textDisabled,
          size: 64,
        ),
        title: l10n.exerciseNoExercisesYet,
        subtitle: l10n.exerciseCheckBackSoon,
        action: AppPrimaryButton(
          label: l10n.exerciseListTodayExercises,
          onPressed: onBackToToday,
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(l10n.exerciseListAllExercises),
          leading: BackButton(
            color: AppColors.textPrimary,
            onPressed: onBackToToday,
          ),
          floating: true,
          snap: true,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingH,
            vertical: 8,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final exercise = exercises[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.cardGap),
                child: ExerciseCard(
                  exercise: exercise,
                  orderNumber: index + 1,
                  onTap: () => context.pushNamed(
                    RouteNames.exerciseDetail,
                    pathParameters: {'id': exercise.id},
                  ),
                ),
              );
            }, childCount: exercises.length),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
