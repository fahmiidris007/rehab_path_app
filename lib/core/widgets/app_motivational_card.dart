import 'package:flutter/material.dart';
import 'package:rehab_path_app/app/theme/app_colors.dart';
import 'package:rehab_path_app/app/theme/app_text_styles.dart';

/// A motivational quote card styled as a speech bubble.
///
/// Background: [AppColors.primaryLight] (#0079C3)
/// Shape: speech-bubble — top-left corner is square (0dp), all other corners
/// are rounded at 12dp. This matches the Figma design where the bubble "tail"
/// originates from the top-left.
/// Padding: 24dp on all sides.
class AppMotivationalCard extends StatelessWidget {
  const AppMotivationalCard({
    super.key,
    required this.message,
    this.author,
    this.icon,
  });

  /// The motivational message to display.
  final String message;

  /// Optional author attribution shown below the message.
  final String? author;

  /// Optional icon widget shown above the message.
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        // Speech-bubble shape: top-left is square (0dp), others are 12dp.
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(height: 12),
          ],
          Text(
            message,
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              fontSize: 14
            ),
          ),
          if (author != null) ...[
            const SizedBox(height: 8),
            Text(
              author!,
              style: AppTextStyles.bodySemiBold.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
