import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/zero_state_widget.dart';
import '../../../../di/injection.dart';
import '../../../../features/home/presentation/cubit/home_cubit.dart';
import '../../../../features/home/presentation/cubit/home_state.dart';
import '../../../../shared/data/datasources/hive_data_source.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../domain/usecases/get_exercise_by_id_use_case.dart';

/// Displays the full details of a single exercise.
///
/// Receives [exerciseId] from the route path parameter `id` and loads the
/// exercise directly via [GetExerciseByIdUseCase].
class ExerciseDetailPage extends StatefulWidget {
  const ExerciseDetailPage({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  ExerciseEntity? _exercise;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadExercise();
  }

  Future<void> _loadExercise() async {
    final useCase = getIt<GetExerciseByIdUseCase>();
    final result = await useCase(GetExerciseByIdParams(widget.exerciseId));
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _error = failure.when(
          server: (msg, _) => msg,
          cache: (msg) => msg,
          validation: (msg, _) => msg,
          unexpected: (msg) => msg,
        );
        _loading = false;
      }),
      (exercise) => setState(() {
        _exercise = exercise;
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
        body: ZeroStateWidget(
          icon: const Icon(Icons.error_outline, color: AppColors.error, size: 64),
          title: 'Could not load exercise',
          subtitle: _error,
          action: TextButton(
            onPressed: () {
              setState(() {
                _loading = true;
                _error = null;
              });
              _loadExercise();
            },
            child: const Text('Retry'),
          ),
        ),
      );
    }

    final exercise = _exercise!;
    return _ExerciseDetailView(exercise: exercise);
  }
}

// ── Detail view ───────────────────────────────────────────────────────────────

class _ExerciseDetailView extends StatelessWidget {
  const _ExerciseDetailView({required this.exercise});

  final ExerciseEntity exercise;

  /// Returns true if this exercise has been completed today by the current user.
  bool _isCompletedToday(BuildContext context) {
    try {
      final homeCubit = getIt<HomeCubit>();
      if (homeCubit.state is! HomeLoaded) return false;
      final data = (homeCubit.state as HomeLoaded).data;
      final userId = data.user.id;

      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);

      return getIt<HiveDataSource>()
          .getAllSessions()
          .any((s) =>
              s.userId == userId &&
              s.exerciseId == exercise.id &&
              s.completedAt.isAfter(todayStart));
    } catch (_) {
      return false;
    }
  }

  /// Returns the next exercise in today's schedule after this one, or null.
  ExerciseEntity? _getNextExercise(BuildContext context) {
    try {
      final homeCubit = getIt<HomeCubit>();
      if (homeCubit.state is! HomeLoaded) return null;
      final schedule = (homeCubit.state as HomeLoaded).data.todaySchedule;
      final idx = schedule.indexWhere((e) => e.id == exercise.id);
      if (idx == -1 || idx >= schedule.length - 1) return null;
      return schedule[idx + 1];
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to HomeCubit so the UI updates when refreshAfterSession fires.
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: getIt<HomeCubit>(),
      builder: (context, _) {
        final isCompleted = _isCompletedToday(context);
        final nextExercise = _getNextExercise(context);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            scrolledUnderElevation: 1,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenPaddingH,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        // Exercise name
                        Text(
                          exercise.name,
                          style: AppTextStyles.displayH1.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        // Completed badge
                        if (isCompleted) ...[
                          const SizedBox(height: 8),
                          _CompletedBadge(),
                        ],
                        const SizedBox(height: 20),
                        // Placeholder video area
                        _VideoPlaceholder(),
                        const SizedBox(height: 24),
                        // Stats row: duration, sets, reps
                        _StatsRow(exercise: exercise),
                        const SizedBox(height: 24),
                        // Difficulty
                        _SectionLabel(label: 'Difficulty'),
                        const SizedBox(height: 8),
                        _DifficultyIndicator(difficulty: exercise.difficulty),
                        const SizedBox(height: 24),
                        // Step-by-step description
                        _SectionLabel(label: 'How to do it'),
                        const SizedBox(height: 8),
                        if (exercise.steps.isNotEmpty)
                          _StepList(steps: exercise.steps)
                        else
                          Text(
                            exercise.description,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        const SizedBox(height: 24),
                        // Safety tips
                        if (exercise.safetyTips.isNotEmpty) ...[
                          _SectionLabel(label: 'Safety Tips'),
                          const SizedBox(height: 8),
                          _SafetyTipsList(tips: exercise.safetyTips),
                          const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  ),
                ),
                // Action buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.screenPaddingH,
                    12,
                    AppDimensions.screenPaddingH,
                    24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Primary action: start or redo
                      AppPrimaryButton(
                        label: isCompleted ? 'Redo Exercise' : 'Start Exercise',
                        onPressed: () => context.pushNamed(
                          RouteNames.exercisePlayer,
                          pathParameters: {'id': exercise.id},
                        ),
                      ),
                      // Secondary: skip to next (only if in today's schedule and not last)
                      if (nextExercise != null) ...[
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () => context.goNamed(
                            RouteNames.exerciseDetail,
                            pathParameters: {'id': nextExercise.id},
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(
                              double.infinity,
                              AppDimensions.primaryButtonH,
                            ),
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusButton),
                            ),
                          ),
                          child: Text('Next: ${nextExercise.name}'),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Completed badge ───────────────────────────────────────────────────────────

class _CompletedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 16, color: AppColors.success),
          const SizedBox(width: 6),
          Text(
            'Completed today',
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Video placeholder ─────────────────────────────────────────────────────────

class _VideoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.neutralGray,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      child: const Center(
        child: Icon(
          Icons.play_circle_outline,
          size: 64,
          color: AppColors.textDisabled,
        ),
      ),
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.exercise});

  final ExerciseEntity exercise;

  @override
  Widget build(BuildContext context) {
    final durationMin = (exercise.durationSeconds / 60).ceil();
    return Row(
      children: [
        _StatChip(
          icon: Icons.timer_outlined,
          label: '$durationMin min',
        ),
        const SizedBox(width: 12),
        _StatChip(
          icon: Icons.repeat,
          label: '${exercise.sets} sets',
        ),
        const SizedBox(width: 12),
        _StatChip(
          icon: Icons.fitness_center,
          label: '${exercise.reps} reps',
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.bodySemiBold.copyWith(
        color: AppColors.textPrimary,
      ),
    );
  }
}

// ── Step list ─────────────────────────────────────────────────────────────────

class _StepList extends StatelessWidget {
  const _StepList({required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final step = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 13,
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    step,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Difficulty indicator ──────────────────────────────────────────────────────

class _DifficultyIndicator extends StatelessWidget {
  const _DifficultyIndicator({required this.difficulty});

  final int difficulty;

  @override
  Widget build(BuildContext context) {
    const maxDots = 3;
    final filled = difficulty.clamp(1, maxDots);
    final labels = ['Easy', 'Medium', 'Hard'];
    return Row(
      children: [
        ...List.generate(maxDots, (index) {
          final isFilled = index < filled;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFilled ? AppColors.accent : AppColors.neutralGray,
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        Text(
          labels[(filled - 1).clamp(0, 2)],
          style: AppTextStyles.body.copyWith(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ── Safety tips list ──────────────────────────────────────────────────────────

class _SafetyTipsList extends StatelessWidget {
  const _SafetyTipsList({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tips.map((tip) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Icon(
                  Icons.shield_outlined,
                  size: 16,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tip,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
