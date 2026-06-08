import 'package:flutter/material.dart';
import 'package:teman_lansia/app/theme/app_colors.dart';
import 'package:teman_lansia/app/theme/app_text_styles.dart';

/// An inline error display widget (not full-screen).
///
/// Shows a red error icon alongside an error message. An optional retry
/// callback renders a "Retry" text button below the message row.
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  /// The error message to display.
  final String message;

  /// Optional callback invoked when the user taps the retry button.
  /// When null, no retry button is shown.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Retry',
              style: AppTextStyles.bodySemiBold.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
