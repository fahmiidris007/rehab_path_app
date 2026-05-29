import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';

/// Shared rounded "frame" used by both the preview and player video surfaces so
/// they match the look of the old static placeholder (rounded card, neutral
/// background).
class _VideoFrame extends StatelessWidget {
  const _VideoFrame({required this.child, this.aspectRatio});

  final Widget child;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      child: AspectRatio(
        aspectRatio: aspectRatio ?? 16 / 9,
        child: Container(color: AppColors.neutralGray, child: child),
      ),
    );
  }
}

/// Fallback shown when a clip cannot be loaded — mirrors the previous static
/// placeholder so the detail screen never looks broken.
class _VideoUnavailable extends StatelessWidget {
  const _VideoUnavailable();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.videocam_off_outlined,
            size: 56,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.exerciseVideoUnavailable,
            style: const TextStyle(
              fontFamily: 'PublicSans',
              fontSize: 14,
              color: AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }
}

/// Auto-playing, looping, muted preview of an exercise clip shown on the
/// exercise detail screen.
///
/// While the app is offline-first the same sample clip is reused for every
/// exercise (see `AppConstants.assetExerciseDetailVideo`). The widget owns its
/// own [VideoPlayerController], plays on a tap-to-toggle basis, and degrades
/// gracefully to a static placeholder if the asset fails to initialise.
class ExerciseVideoPreview extends StatefulWidget {
  const ExerciseVideoPreview({super.key, required this.assetPath});

  final String assetPath;

  @override
  State<ExerciseVideoPreview> createState() => _ExerciseVideoPreviewState();
}

class _ExerciseVideoPreviewState extends State<ExerciseVideoPreview> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _failed = false;
  bool _muted = true;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    final controller = VideoPlayerController.asset(widget.assetPath);
    try {
      await controller.initialize();
      await controller.setLooping(true);
      // Start muted so the autoplay preview doesn't blast audio on open; the
      // user can unmute via the speaker toggle.
      await controller.setVolume(0);
      await controller.play();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _initialized = true;
      });
    } catch (_) {
      await controller.dispose();
      if (!mounted) return;
      setState(() => _failed = true);
    }
  }

  void _togglePlayback() {
    final controller = _controller;
    if (controller == null) return;
    setState(() {
      if (controller.value.isPlaying) {
        controller.pause();
      } else {
        controller.play();
      }
    });
  }

  void _toggleMute() {
    final controller = _controller;
    if (controller == null) return;
    setState(() {
      _muted = !_muted;
      controller.setVolume(_muted ? 0 : 1.0);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_failed) {
      return const _VideoFrame(child: _VideoUnavailable());
    }

    final controller = _controller;
    if (!_initialized || controller == null) {
      return const _VideoFrame(
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final isPlaying = controller.value.isPlaying;

    return Semantics(
      label: l10n.exerciseVideoSemanticLabel,
      button: true,
      child: _VideoFrame(
        aspectRatio: controller.value.aspectRatio,
        child: GestureDetector(
          onTap: _togglePlayback,
          child: Stack(
            fit: StackFit.expand,
            children: [
              VideoPlayer(controller),
              // Dim + play icon while paused so the affordance is obvious.
              if (!isPlaying)
                ColoredBox(
                  color: Colors.black.withValues(alpha: 0.25),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
              // Mute / unmute toggle (bottom-right).
              Positioned(
                right: 8,
                bottom: 8,
                child: _MuteButton(
                  muted: _muted,
                  onPressed: _toggleMute,
                  muteLabel: l10n.exerciseVideoMute,
                  unmuteLabel: l10n.exerciseVideoUnmute,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Circular speaker button overlaid on the preview to toggle audio.
class _MuteButton extends StatelessWidget {
  const _MuteButton({
    required this.muted,
    required this.onPressed,
    required this.muteLabel,
    required this.unmuteLabel,
  });

  final bool muted;
  final VoidCallback onPressed;
  final String muteLabel;
  final String unmuteLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: muted ? unmuteLabel : muteLabel,
      child: Material(
        color: Colors.black.withValues(alpha: 0.5),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            // Keeps the tappable area comfortably large for older users.
            padding: const EdgeInsets.all(10),
            child: Icon(
              muted ? Icons.volume_off : Icons.volume_up,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Renders the looping clip that backs the exercise player.
///
/// Unlike [ExerciseVideoPreview] this widget does **not** own the controller —
/// playback (play/pause/loop) is driven by the surrounding player so the video
/// stays in lock-step with the session state and countdown. The controller is
/// expected to already be initialised; a spinner is shown otherwise.
class ExercisePlayerVideo extends StatelessWidget {
  const ExercisePlayerVideo({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        if (!value.isInitialized) {
          return const _VideoFrame(
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        return _VideoFrame(
          aspectRatio: value.aspectRatio,
          child: VideoPlayer(controller),
        );
      },
    );
  }
}
