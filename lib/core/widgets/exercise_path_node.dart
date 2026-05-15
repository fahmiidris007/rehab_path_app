import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';

/// Visual state of an exercise path node.
enum ExerciseNodeState {
  /// The current active exercise — largest, accent-coloured with glow.
  active,

  /// A completed exercise — medium, primary-coloured.
  completed,

  /// A locked exercise — smallest, gray.
  locked,
}

/// A node on the exercise path map.
///
/// Renders a circle whose size and colour depend on [state], with an [icon]
/// centred inside and a [label] below. Tapping calls [onTap] when provided.
class ExercisePathNode extends StatelessWidget {
  const ExercisePathNode({
    super.key,
    required this.state,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final ExerciseNodeState state;
  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = _sizeFor(state);
    final bgColor = _bgColorFor(state);
    final shadows = _shadowsFor(state);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.background,
                width: 4,
              ),
              boxShadow: shadows,
            ),
            child: Center(child: icon),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static double _sizeFor(ExerciseNodeState state) {
    switch (state) {
      case ExerciseNodeState.active:
        return AppDimensions.nodeActive;
      case ExerciseNodeState.completed:
        return AppDimensions.nodeCompleted;
      case ExerciseNodeState.locked:
        return AppDimensions.nodeLocked;
    }
  }

  static Color _bgColorFor(ExerciseNodeState state) {
    switch (state) {
      case ExerciseNodeState.active:
        return AppColors.accent;
      case ExerciseNodeState.completed:
        return AppColors.primary;
      case ExerciseNodeState.locked:
        return AppColors.neutralGray;
    }
  }

  static List<BoxShadow> _shadowsFor(ExerciseNodeState state) {
    if (state == ExerciseNodeState.active) {
      return const [
        BoxShadow(
          color: Color(0x66FFA454), // accent with ~40% opacity
          blurRadius: 16,
          spreadRadius: 4,
          offset: Offset(0, 4),
        ),
      ];
    }
    return const [];
  }
}
