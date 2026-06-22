import 'package:flutter/material.dart';
import 'package:laman_lansia/app/theme/app_colors.dart';
import 'package:laman_lansia/app/theme/app_dimensions.dart';

/// A general-purpose card with the Laman Lansia card style.
///
/// Background: [AppColors.background] (#F9F9F9)
/// Border: 1px [AppColors.border] (#C0C7D3), radius 12dp
/// Shadow: subtle blue-tinted drop shadow
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding});

  /// The widget to display inside the card.
  final Widget child;

  /// Padding around [child]. Defaults to [EdgeInsets.all(AppDimensions.cardPadding)].
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A00629F),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
