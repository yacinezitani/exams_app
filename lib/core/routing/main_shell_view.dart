import 'package:exam_app/core/widgets/app_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Hosts the four bottom-nav branches; each keeps its own navigation state.
class MainShellView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellView({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        selectedIndex: navigationShell.currentIndex,
        // Re-tapping the current tab returns it to its root.
        onSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
