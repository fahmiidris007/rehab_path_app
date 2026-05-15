import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/app_bottom_nav_bar.dart';
import 'route_names.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => _onTap(context, index),
      ),
    );
  }

  int _locationToIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/exercise')) return 1;
    if (location.startsWith('/progress')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed(RouteNames.home);
      case 1:
        context.goNamed(RouteNames.exerciseList);
      case 2:
        context.goNamed(RouteNames.progress);
      case 3:
        context.goNamed(RouteNames.profile);
    }
  }
}
