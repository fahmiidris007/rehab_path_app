import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../features/home/domain/utils/greeting_utils.dart';

/// Displays a time-based greeting and the user's first name.
///
/// Example:
/// ```
/// Good morning,
/// John
/// ```
class GreetingHeader extends StatelessWidget {
  const GreetingHeader({required this.firstName, super.key});

  /// The user's first name (or full name — only the first word is shown).
  final String firstName;

  @override
  Widget build(BuildContext context) {
    final greeting = getGreeting(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting,',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          firstName,
          style:
              AppTextStyles.displayH1.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
