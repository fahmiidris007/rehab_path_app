import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/zero_state_widget.dart';
import '../../../../di/injection.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../features/auth/presentation/cubit/auth_state.dart';
import '../../../../features/home/presentation/cubit/home_cubit.dart';
import '../../../../features/progress/presentation/cubit/progress_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/usecases/get_exercise_by_id_use_case.dart';
import '../cubit/exercise_player_cubit.dart';
import '../cubit/player_state.dart';
import '../widgets/exercise_video.dart';
import 'post_save_navigation.dart';

/// Plays an exercise session for the given [exerciseId].
///
/// Provides its own [ExercisePlayerCubit] via [BlocProvider] and starts the
/// exercise on initialisation. Handles all relevant [PlayerState] transitions:
/// - [PlayerPlaying] / [PlayerPaused]: shows countdown timer + controls
/// - [PlayerSaved]: navigates to the next incomplete exercise (or home)
/// - [PlayerError]: shows an error snackbar
///
/// Back press calls [ExercisePlayerCubit.cancelSession] before popping. The
/// player observes app lifecycle changes and auto-pauses on background.
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

  /// Looping demo clip that backs the player. Owned here so its lifecycle is
  /// tied to the loader; passed down (read-only) to [_PlayerView]. May stay
  /// null if the asset fails to initialise, in which case the player simply
  /// shows the countdown with no video.
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _loadAndStart();
  }

  Future<void> _loadAndStart() async {
    final useCase = getIt<GetExerciseByIdUseCase>();
    final result = await useCase(GetExerciseByIdParams(widget.exerciseId));
    if (!mounted) return;

    final exercise = result.fold((_) => null, (e) => e);
    if (exercise == null) {
      setState(() {
        _error = result.fold(
          (failure) => failure.when(
            server: (msg, _) => msg,
            cache: (msg) => msg,
            validation: (msg, _) => msg,
            unexpected: (msg) => msg,
          ),
          (_) => null,
        );
        _loading = false;
      });
      return;
    }

    // Prepare the looping demo clip. While the app is offline-first the same
    // sample video is reused for every exercise, and the session runs for
    // `exercisePlayerVideoLoopCount` loops of it. If the asset fails to load
    // we fall back to the exercise's own configured duration and no video.
    var sessionExercise = exercise;
    final controller = VideoPlayerController.asset(
      AppConstants.assetExercisePlayerVideo,
    );
    try {
      await controller.initialize();
      await controller.setLooping(true);
      // Audio on: the demo clip narrates/cues the exercise during the session.
      await controller.setVolume(1.0);
      final clipMs = controller.value.duration.inMilliseconds;
      if (clipMs > 0) {
        final loopedSeconds =
            (clipMs * AppConstants.exercisePlayerVideoLoopCount / 1000).round();
        sessionExercise = exercise.copyWith(
          durationSeconds: loopedSeconds < 1 ? 1 : loopedSeconds,
        );
      }
      await controller.play();
      _videoController = controller;
    } catch (_) {
      await controller.dispose();
      _videoController = null;
    }

    if (!mounted) {
      _videoController?.dispose();
      _videoController = null;
      return;
    }

    // Resolve the current userId from AuthCubit. Falls back to empty string
    // when no authenticated user is present; the cubit handles that case
    // gracefully.
    final authState = getIt<AuthCubit>().state;
    final userId = switch (authState) {
      AuthAuthenticated(:final user) => user.id,
      _ => '',
    };
    context.read<ExercisePlayerCubit>().startExercise(
      sessionExercise,
      userId: userId,
    );
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
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
        body: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return ZeroStateWidget(
              icon: const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 64,
              ),
              title: l10n.exerciseCouldNotLoad,
              subtitle: _error,
            );
          },
        ),
      );
    }

    return _PlayerView(videoController: _videoController);
  }
}

// ── Player view ───────────────────────────────────────────────────────────────

class _PlayerView extends StatefulWidget {
  const _PlayerView({this.videoController});

  /// Looping demo clip, already initialised and playing. Null when the asset
  /// could not be loaded — the player then runs without a video surface.
  final VideoPlayerController? videoController;

  @override
  State<_PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<_PlayerView> with WidgetsBindingObserver {
  /// Cached cubit reference used from lifecycle callbacks where reading
  /// from [BuildContext] may not be safe (e.g. when the framework reports
  /// a backgrounded app).
  ExercisePlayerCubit? _cubitRef;

  final Logger _log = Logger();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Capture the cubit so didChangeAppLifecycleState can call onAppPaused
    // without touching the widget tree.
    _cubitRef = context.read<ExercisePlayerCubit>();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      final cubit = _cubitRef;
      if (cubit != null) {
        cubit.onAppPaused();
      }
    }
  }

  /// After a session is saved, navigate to the next incomplete exercise in
  /// today's schedule, or back to home if all exercises are done. When all
  /// of today's schedule is complete, also surface a localized SnackBar.
  ///
  /// Routing decision is delegated to [PostSaveNavigation.decide] so the
  /// pure routing logic can be exercised by property tests without spinning
  /// up a widget tree (Property 15 / Requirement 10.5).
  void _navigateAfterSave(BuildContext context) {
    try {
      final homeCubit = getIt<HomeCubit>();
      final route = PostSaveNavigation.decide(
        nextExercise: homeCubit.getNextIncompleteExercise(),
        allTodayDone: homeCubit.allTodayExercisesDone,
      );

      switch (route) {
        case ExerciseDetailRoute(:final id):
          // Replace the current player route with the next exercise's
          // detail page; keeps the shell nav bar visible.
          context.goNamed(
            RouteNames.exerciseDetail,
            pathParameters: {'id': id},
          );
        case HomeRoute(:final allTodayDone):
          // All of today's schedule is complete (or no next exercise) —
          // return to home and, when the schedule is fully done, surface
          // a localized confirmation message.
          context.goNamed(RouteNames.home);
          if (allTodayDone) {
            final l10n = AppLocalizations.of(context);
            if (l10n != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.exerciseListAllDoneToday)),
              );
            }
          }
      }
    } catch (_) {
      context.goNamed(RouteNames.home);
    }
  }

  /// Triggers a data refresh on HomeCubit and ProgressCubit after a session
  /// is saved, so both the dashboard and progress page reflect the new data.
  ///
  /// Returns a Future that completes only after [HomeCubit.refreshAfterSession]
  /// has finished. Callers MUST await this before navigating, otherwise the
  /// destination page may render before the dashboard has emitted a
  /// non-loading state (R11.5, R11.6).
  Future<void> _refreshDashboardAndProgress(BuildContext context) async {
    try {
      final authState = getIt<AuthCubit>().state;
      final userId = switch (authState) {
        AuthAuthenticated(:final user) => user.id,
        _ => null,
      };
      if (userId != null) {
        // Refresh home dashboard stats (streak, completedToday, etc.) and
        // wait for the cubit to settle on a non-loading state before
        // returning so the listener can safely navigate.
        await getIt<HomeCubit>().refreshAfterSession();

        // Reload progress data (adherence, badges, etc.) — fire and forget
        // is fine here; the progress page is not the immediate post-save
        // destination.
        getIt<ProgressCubit>().loadProgress(userId);
      }
    } catch (_) {
      // Silently ignore if cubits are not yet registered
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoController = widget.videoController;
    return BlocConsumer<ExercisePlayerCubit, PlayerState>(
      listener: (context, state) async {
        // Keep the looping demo clip in lock-step with the session state:
        // play while the timer runs, pause when paused/saving, and stop once
        // the session is saved.
        _syncVideo(state);
        switch (state) {
          case PlayerSaved():
            // Refresh data first, then navigate to the next incomplete
            // exercise or back to home if all are done. Awaiting the
            // refresh guarantees HomeCubit has emitted a non-loading
            // state before the destination page renders (R11.5, R11.6).
            await _refreshDashboardAndProgress(context);
            if (!context.mounted) return;
            _navigateAfterSave(context);
          case PlayerError(:final message):
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          default:
            break;
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            try {
              await context.read<ExercisePlayerCubit>().cancelSession();
            } catch (e, st) {
              // Cancellation is best-effort; log and proceed so the user is
              // never trapped on the player screen.
              _log.w(
                'cancelSession failed during back press',
                error: e,
                stackTrace: st,
              );
            }
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenPaddingH,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            // Looping demo clip (only when the asset loaded).
                            if (videoController != null) ...[
                              const SizedBox(height: 8),
                              ExercisePlayerVideo(controller: videoController),
                            ],
                            // Countdown + progress take the remaining space and
                            // stay centered when there's room; on small screens
                            // or large font scales the whole view scrolls.
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 24),
                                    _CountdownDisplay(state: state),
                                    const SizedBox(height: 16),
                                    _ProgressSection(state: state),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ),
                            // Controls
                            _ControlsRow(state: state),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  /// Mirrors the looping demo clip onto the current [PlayerState]: it plays
  /// while [PlayerPlaying], and pauses for every other state. Safe to call
  /// when no video was loaded.
  void _syncVideo(PlayerState state) {
    final controller = widget.videoController;
    if (controller == null || !controller.value.isInitialized) return;
    final shouldPlay = state is PlayerPlaying;
    if (shouldPlay && !controller.value.isPlaying) {
      controller.play();
    } else if (!shouldPlay && controller.value.isPlaying) {
      controller.pause();
    }
  }

  Widget? _exerciseName(PlayerState state) {
    final name = switch (state) {
      PlayerPlaying(:final exercise) => exercise.name,
      PlayerPaused(:final exercise) => exercise.name,
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
          Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              return Text(
                l10n.exercisePlayerPaused,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textDisabled,
                ),
              );
            },
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
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
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
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<ExercisePlayerCubit>();
    final isPlaying = state is PlayerPlaying;
    final isActive = state is PlayerPlaying || state is PlayerPaused;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pause / Resume button
        Expanded(
          child: AppPrimaryButton(
            label: isPlaying ? l10n.exercisePause : l10n.exerciseResume,
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
          label: Text(l10n.exerciseSkip),
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
