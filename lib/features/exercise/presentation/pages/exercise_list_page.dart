import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_outline_button.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/zero_state_widget.dart';
import '../../../../di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/exercise_list_cubit.dart';
import '../cubit/exercise_list_state.dart';
import '../widgets/exercise_card.dart';

/// Displays today's scheduled exercises by default and offers a toggle to
/// switch to the full grouped catalogue.
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
                  todaySchedule: todaySchedule,
                  onSwitchToAllMode: cubit.switchToAllMode,
                ),
              ExerciseListAllMode(:final allExercises) => _ExerciseGroupedList(
                  exercises: allExercises,
                  onBackToToday: () => cubit.switchToTodayMode(userId),
                  trailing: AppOutlineButton(
                    label: l10n.exerciseListTodayExercises,
                    onPressed: () => cubit.switchToTodayMode(userId),
                  ),
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
    required this.todaySchedule,
    required this.onSwitchToAllMode,
  });

  final List<ExerciseEntity> todaySchedule;
  final VoidCallback onSwitchToAllMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (todaySchedule.isEmpty) {
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
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final exercise = todaySchedule[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.cardGap),
                  child: ExerciseCard(
                    exercise: exercise,
                    onTap: () => context.pushNamed(
                      RouteNames.exerciseDetail,
                      pathParameters: {'id': exercise.id},
                    ),
                  ),
                );
              },
              childCount: todaySchedule.length,
            ),
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
            child: AppPrimaryButton(
              label: l10n.exerciseListAllExercises,
              onPressed: onSwitchToAllMode,
            ),
          ),
        ),
      ],
    );
  }
}

// ── All mode: grouped list ────────────────────────────────────────────────────

class _ExerciseGroupedList extends StatelessWidget {
  const _ExerciseGroupedList({
    required this.exercises,
    this.trailing,
    this.onBackToToday,
  });

  final List<ExerciseEntity> exercises;

  /// Optional widget rendered after the last category group (e.g. a toggle
  /// back to today mode).
  final Widget? trailing;

  /// Callback for the AppBar back button. When non-null, a back arrow is
  /// shown in the AppBar so the user can return to today mode without
  /// scrolling to the bottom of the list.
  final VoidCallback? onBackToToday;

  Map<ExerciseCategory, List<ExerciseEntity>> _groupByCategory() {
    final map = <ExerciseCategory, List<ExerciseEntity>>{};
    for (final exercise in exercises) {
      map.putIfAbsent(exercise.category, () => []).add(exercise);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (exercises.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: onBackToToday != null
              ? BackButton(
                  color: AppColors.textPrimary,
                  onPressed: onBackToToday,
                )
              : null,
          automaticallyImplyLeading: onBackToToday != null,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
        body: ZeroStateWidget(
          icon: const Icon(
            Icons.fitness_center,
            color: AppColors.textDisabled,
            size: 64,
          ),
          title: l10n.exerciseNoExercisesYet,
          subtitle: l10n.exerciseCheckBackSoon,
          action: trailing,
        ),
      );
    }

    final grouped = _groupByCategory();
    final slivers = <Widget>[
      SliverAppBar(
        title: Text(l10n.exerciseListTitle),
        // Back button to return to today mode — visible whenever the user
        // is browsing the full catalogue.
        leading: onBackToToday != null
            ? BackButton(
                color: AppColors.textPrimary,
                onPressed: onBackToToday,
              )
            : null,
        automaticallyImplyLeading: onBackToToday != null,
        floating: true,
        snap: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
    ];

    for (final entry in grouped.entries) {
      final category = entry.key;
      final items = entry.value;

      slivers.add(
        SliverPersistentHeader(
          pinned: true,
          delegate: _CategoryHeaderDelegate(
            category: category,
            count: items.length,
          ),
        ),
      );

      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingH,
            vertical: 8,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final exercise = items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.cardGap),
                  child: ExerciseCard(
                    exercise: exercise,
                    onTap: () => context.pushNamed(
                      RouteNames.exerciseDetail,
                      pathParameters: {'id': exercise.id},
                    ),
                  ),
                );
              },
              childCount: items.length,
            ),
          ),
        ),
      );
    }

    if (trailing != null) {
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.screenPaddingH,
            8,
            AppDimensions.screenPaddingH,
            24,
          ),
          sliver: SliverToBoxAdapter(child: trailing),
        ),
      );
    } else {
      slivers.add(const SliverToBoxAdapter(child: SizedBox(height: 24)));
    }

    return CustomScrollView(slivers: slivers);
  }
}

// ── Category header delegate ──────────────────────────────────────────────────

class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  _CategoryHeaderDelegate({
    required this.category,
    required this.count,
  });

  final ExerciseCategory category;
  final int count;

  static const double _height = 48.0;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: _height,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            child: Text(
              _categoryLabel(category, l10n),
              style: AppTextStyles.bodySemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.neutralGray,
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            ),
            child: Text(
              '$count',
              style: AppTextStyles.body.copyWith(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_CategoryHeaderDelegate oldDelegate) =>
      oldDelegate.category != category || oldDelegate.count != count;

  static String _categoryLabel(
    ExerciseCategory category,
    AppLocalizations l10n,
  ) {
    switch (category) {
      case ExerciseCategory.warmUp:
        return l10n.exerciseCategoryWarmUp;
      case ExerciseCategory.balanceTraining:
        return l10n.exerciseCategoryBalanceTraining;
      case ExerciseCategory.strengthTraining:
        return l10n.exerciseCategoryStrengthTraining;
      case ExerciseCategory.enduranceAerobic:
        return l10n.exerciseCategoryEnduranceAerobic;
      case ExerciseCategory.taiChi:
        return l10n.exerciseCategoryTaiChi;
      case ExerciseCategory.walkingProgram:
        return l10n.exerciseCategoryWalkingProgram;
      case ExerciseCategory.gettingUpFromFloor:
        return l10n.exerciseCategoryGettingUpFromFloor;
      case ExerciseCategory.coolDown:
        return l10n.exerciseCategoryCoolDown;
    }
  }
}
