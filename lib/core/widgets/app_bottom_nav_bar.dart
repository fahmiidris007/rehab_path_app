import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';

/// A tab descriptor for [AppBottomNavBar].
class _NavTab {
  const _NavTab({required this.icon, required this.label});
  final Widget icon;
  final String label;
}

/// Custom bottom navigation bar with 4 tabs.
///
/// [currentIndex] selects the active tab (0 = Home, 1 = Exercise/Map,
/// 2 = Progress, 3 = Profile). [onTap] is called with the tapped index.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_NavTab> _tabs = [
    _NavTab(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
    ),
    _NavTab(
      icon: Icon(Icons.map_outlined),
      label: 'Exercise',
    ),
    _NavTab(
      icon: Icon(Icons.bar_chart_outlined),
      label: 'Progress',
    ),
    _NavTab(
      icon: Icon(Icons.person_outline),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1F00629F),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        height: AppDimensions.bottomNavHeight + bottomPadding,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Row(
            children: List.generate(_tabs.length, (index) {
              return Expanded(
                child: _NavTabItem(
                  tab: _tabs[index],
                  isActive: index == currentIndex,
                  onTap: () => onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavTabItem extends StatelessWidget {
  const _NavTabItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final _NavTab tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? AppColors.textOnPrimary : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppDimensions.recTouchTarget,
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: isActive
                ? BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusNavTab),
                  )
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconTheme(
                  data: IconThemeData(color: color),
                  child: tab.icon,
                ),
                const SizedBox(height: 2),
                Text(
                  tab.label,
                  style: AppTextStyles.labelBottomNavBar.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
