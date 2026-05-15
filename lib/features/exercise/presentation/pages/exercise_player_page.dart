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
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../features/auth/presentation/cubit/auth_state.dart';
import '../../../../features/home/presentation/cubit/home_cubit.dart';
import '../../../../features/progress/presentation/cubit/progress_cubit.dart';
import '../../domain/usecases/get_exercise_by_id_use_case.dart';
import '../cubit/exercise_player_cubit.dart';
import '../cubit/player_state.dart';
import '../widgets/self_report_bottom_sheet.dart';

/// Plays an exercise session for the given [exerciseId].
///
/// Provides its own [ExercisePlayerCubit] via [BlocProvider] and starts the
/// exercise on initialisation. Handles all [PlayerState] transitions:
/// - [PlayerPlaying] / [PlayerPaused]: shows countdown timer + controls
/// - [PlayerSelfReport]: shows [SelfReportBottomSheet]
/// - [PlayerSaved]: navigates back to the exercise list
/// - [PlayerError]: shows an error state
///
/// Back press calls [ExercisePlayerCubit.cancelSession] before popping.
class ExercisePlayerPage extends StatelessWidget {
  const ExercisePlayerPage({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExercisePlayerCubit>(
      create: (_) => getIt<ExercisePlayerCubit>(),
      child: _ExercisePlayerLoader(exerciseId: exerciseId),
    );
  }
}

// ── Loader — fetches exercise then starts the player ─────────────────────────

class _ExercisePlayerLoader extends StatefulWidget {
  const _ExercisePlayerLoader({required this.exerciseId});

  final String exerciseId;

  @override
  State<_ExercisePlayerLoader> createState() => _ExercisePlayerLoaderState();
}

class _ExercisePlayerLoaderState extends State<_ExercisePlayerLoader> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAndStart();
  }

  Future<void> _loadAndStart() async {
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
      (exercise) {
        context.read<ExercisePlayerCubit>().startExercise(exercise);
        setState(() => _loading = false);
      },
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
        ),
      );
    }

    return const _PlayerView();
  }
}

// ── Player view ───────────────────────────────────────────────────────────────

class _PlayerView extends StatefulWidget {
  const _PlayerView();

  @override
  State<_PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<_PlayerView> {
  bool _selfReportShown = false;

  /// After a session is saved, navigate to the next incomplete exercise in
  /// today's schedule, or back to home if all exercises are done.
  void _navigateAfterSave(BuildContext context) {
    try {
      final homeCubit = getIt<HomeCubit>();
      final nextExercise = homeCubit.getNextIncompleteExercise();

      if (nextExercise != null && !homeCubit.allTodayExercisesDone) {
        // Go to the detail page of the next exercise.
        // Use goNamed to replace the current player in the stack with the
        // next exercise detail, keeping the shell nav bar visible.
        context.goNamed(
          RouteNames.exerciseDetail,
          pathParameters: {'id': nextExercise.id},
        );
      } else {
        // All done — go back to home dashboard.
        context.goNamed(RouteNames.home);
      }
    } catch (_) {
      context.goNamed(RouteNames.home);
    }
  }

  /// Triggers a data refresh on HomeCubit and ProgressCubit after a session
  /// is saved, so both the dashboard and progress page reflect the new data.
  void _refreshDashboardAndProgress(BuildContext context) {
    // Both cubits are @lazySingleton — we can access them via getIt and
    // call refresh methods directly, regardless of where we are in the tree.
    try {
      final authState = getIt<AuthCubit>().state;
      final userId = switch (authState) {
        AuthAuthenticated(:final user) => user.id,
        _ => null,
      };
      if (userId != null) {
        // Refresh home dashboard stats (streak, completedToday, etc.)
        getIt<HomeCubit>().refreshAfterSession();

        // Reload progress data (adherence, badges, etc.)
        getIt<ProgressCubit>().loadProgress(userId);
      }
    } catch (_) {
      // Silently ignore if cubits are not yet registered
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExercisePlayerCubit, PlayerState>(
      listener: (context, state) {
        switch (state) {
          case PlayerSelfReport(:final exercise):
            if (!_selfReportShown) {
              _selfReportShown = true;
              SelfReportBottomSheet.show(context, exercise: exercise).then((_) {
                _selfReportShown = false;
              });
            }
          case PlayerSaved():
            // Refresh data first, then navigate to the next incomplete exercise
            // or back to home if all are done.
            _refreshDashboardAndProgress(context);
            _navigateAfterSave(context);
          case PlayerError(:final message):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          default:
            break;
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            await context.read<ExercisePlayerCubit>().cancelSession();
            if (context.mounted) context.pop();
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
              title: _exerciseName(state),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPaddingH,
                ),
                child: Column(
                  children: [
                    const Spacer(),
                    // Countdown timer
                    _CountdownDisplay(state: state),
                    const SizedBox(height: 16),
                    // Progress bar
                    _ProgressSection(state: state),
                    const Spacer(),
                    // Controls
                    _ControlsRow(state: state),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget? _exerciseName(PlayerState state) {
    final name = switch (state) {
      PlayerPlaying(:final exercise) => exercise.name,
      PlayerPaused(:final exercise) => exercise.name,
      PlayerSelfReport(:final exercise) => exercise.name,
      PlayerIdle(:final exercise) => exercise.name,
      _ => null,
    };
    if (name == null) return null;
    return Text(
      name,
      style: AppTextStyles.h2AppBar.copyWith(color: AppColors.textPrimary),
    );
  }
}

// ── Countdown display ─────────────────────────────────────────────────────────

class _CountdownDisplay extends StatelessWidget {
  const _CountdownDisplay({required this.state});

  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    final seconds = switch (state) {
      PlayerPlaying(:final remainingSeconds) => remainingSeconds,
      PlayerPaused(:final remainingSeconds) => remainingSeconds,
      _ => 0,
    };

    final isPaused = state is PlayerPaused;
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    final timeStr =
        '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

    return Column(
      children: [
        Text(
          timeStr,
          style: TextStyle(
            fontFamily: 'PublicSans',
            fontWeight: FontWeight.bold,
            fontSize: 48,
            color: isPaused ? AppColors.textDisabled : AppColors.textPrimary,
          ),
        ),
        if (isPaused) ...[
          const SizedBox(height: 8),
          Text(
            'Paused',
            style: AppTextStyles.body.copyWith(color: AppColors.textDisabled),
          ),
        ],
      ],
    );
  }
}

// ── Progress section ──────────────────────────────────────────────────────────

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.state});

  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    final (remaining, total) = switch (state) {
      PlayerPlaying(:final remainingSeconds, :final exercise) => (
          remainingSeconds,
          exercise.durationSeconds,
        ),
      PlayerPaused(:final remainingSeconds, :final exercise) => (
          remainingSeconds,
          exercise.durationSeconds,
        ),
      _ => (0, 1),
    };

    final progress = total > 0 ? 1.0 - (remaining / total) : 0.0;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: AppDimensions.progressBarH,
            backgroundColor: AppColors.neutralGray,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
        ),
      ],
    );
  }
}

// ── Controls row ──────────────────────────────────────────────────────────────

class _ControlsRow extends StatelessWidget {
  const _ControlsRow({required this.state});

  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExercisePlayerCubit>();
    final isPlaying = state is PlayerPlaying;
    final isActive = state is PlayerPlaying || state is PlayerPaused;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pause / Resume button
        Expanded(
          child: AppPrimaryButton(
            label: isPlaying ? 'Pause' : 'Resume',
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: AppColors.textOnPrimary,
            ),
            onPressed: isActive
                ? () {
                    if (isPlaying) {
                      cubit.pause();
                    } else {
                      cubit.resume();
                    }
                  }
                : null,
          ),
        ),
        const SizedBox(width: 16),
        // Skip button
        OutlinedButton.icon(
          onPressed: isActive ? cubit.skip : null,
          icon: const Icon(Icons.skip_next),
          label: const Text('Skip'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(
              AppDimensions.minTouchTarget,
              AppDimensions.primaryButtonH,
            ),
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
            ),
          ),
        ),
      ],
    );
  }
}
