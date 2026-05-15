import 'package:flutter/material.dart';
import 'package:rehab_path_app/app/theme/app_colors.dart';
import 'package:rehab_path_app/app/theme/app_text_styles.dart';

/// A centered loading indicator widget.
///
/// Uses [CircularProgressIndicator.adaptive] so it renders a
/// [CupertinoActivityIndicator] on iOS/macOS and a Material spinner elsewhere.
/// An optional [label] is displayed below the indicator.
class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({
    super.key,
    this.label,
  });

  /// Optional text label shown below the progress indicator.
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          if (label != null) ...[
            const SizedBox(height: 12),
            Text(
              label!,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
