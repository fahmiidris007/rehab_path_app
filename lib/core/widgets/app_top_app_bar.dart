import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';

/// Custom top app bar that implements [PreferredSizeWidget].
///
/// Renders a 56dp-tall bar with a subtle bottom shadow.
class AppTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize =>
      const Size.fromHeight(AppDimensions.topAppBarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.topAppBarHeight +
          MediaQuery.of(context).padding.top,
      decoration: const BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: AppDimensions.topAppBarHeight,
          child: Row(
            children: [
              if (leading != null)
                leading!
              else
                const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h2AppBar.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }
}
