import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/zero_state_widget.dart';
import '../../../../di/injection.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../cubit/exercise_cubit.dart';
import '../cubit/exercise_state.dart';
import '../widgets/exercise_card.dart';

/// Displays all exercises grouped by [ExerciseCategory].
///
/// Provides its own [ExerciseCubit] via [BlocProvider] and loads exercises
/// on initialisation. Uses a [CustomScrollView] with [SliverList] so that
/// category headers can be made sticky.
class ExerciseListPage extends StatelessWidget {
  const ExerciseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExerciseCubit>(
      create: (_) => getIt<ExerciseCubit>()..loadExercises(),
      child: const _ExerciseListView(),
    );
  }
}

class _ExerciseListView extends StatelessWidget {
  const _ExerciseListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ExerciseCubit, ExerciseState>(
        builder: (context, state) {
          return switch (state) {
            ExerciseLoading() => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ExerciseError(:final message) => ZeroStateWidget(
                icon: const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 64,
                ),
                title: 'Something went wrong',
                subtitle: message,
                action: TextButton(
                  onPressed: () =>
                      context.read<ExerciseCubit>().loadExercises(),
                  child: const Text('Retry'),
                ),
              ),
            ExerciseLoaded(:final exercises) when exercises.isEmpty =>
              const ZeroStateWidget(
                icon: Icon(
                  Icons.fitness_center,
                  color: AppColors.textDisabled,
                  size: 64,
                ),
                title: 'No exercises yet',
                subtitle: 'Check back soon for your personalised programme.',
              ),
            ExerciseLoaded(:final exercises) =>
              _ExerciseGroupedList(exercises: exercises),
          };
        },
      ),
    );
  }
}

// ── Grouped list ──────────────────────────────────────────────────────────────

class _ExerciseGroupedList extends StatelessWidget {
  const _ExerciseGroupedList({required this.exercises});

  final List<ExerciseEntity> exercises;

  /// Returns exercises grouped by category, preserving enum declaration order.
  Map<ExerciseCategory, List<ExerciseEntity>> _groupByCategory() {
    final map = <ExerciseCategory, List<ExerciseEntity>>{};
    for (final exercise in exercises) {
      map.putIfAbsent(exercise.category, () => []).add(exercise);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByCategory();
    // Build a flat list of sliver delegates: one header + N cards per category.
    final slivers = <Widget>[
      const SliverAppBar(
        title: Text('Exercises'),
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

      // Sticky category header
      slivers.add(
        SliverPersistentHeader(
          pinned: true,
          delegate: _CategoryHeaderDelegate(
            category: category,
            count: items.length,
          ),
        ),
      );

      // Exercise cards for this category
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

    slivers.add(const SliverToBoxAdapter(child: SizedBox(height: 24)));

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
              _categoryLabel(category),
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

  static String _categoryLabel(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.warmUp:
        return 'Warm Up';
      case ExerciseCategory.balanceTraining:
        return 'Balance Training';
      case ExerciseCategory.strengthTraining:
        return 'Strength Training';
      case ExerciseCategory.enduranceAerobic:
        return 'Endurance / Aerobic';
      case ExerciseCategory.taiChi:
        return 'Tai Chi';
      case ExerciseCategory.walkingProgram:
        return 'Walking Program';
      case ExerciseCategory.gettingUpFromFloor:
        return 'Getting Up From Floor';
      case ExerciseCategory.coolDown:
        return 'Cool Down';
    }
  }
}
