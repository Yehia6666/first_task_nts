import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import 'app_bottom_navigation.dart';
import 'app_nav_scope.dart';

/// App-level navigation shell. Hosts the [StatefulNavigationShell] (one branch
/// per destination) and the bottom navigation bar. The selected bottom-nav item
/// is derived from the active branch, and the shell remembers the previously
/// active branch so [AppNavScope.goBack] can return to it (used by the
/// drawer-only Attendance screen).
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const List<AppBottomNavItem> _navItems = [
    AppBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
    AppBottomNavItem(icon: Icons.event_note_outlined, label: 'Time Off'),
    AppBottomNavItem(
      icon: Icons.account_balance_wallet_outlined,
      label: 'Payroll',
    ),
    AppBottomNavItem(icon: Icons.receipt_long_outlined, label: 'Expense'),
  ];

  /// Bottom-nav index for a branch; drawer-only destinations (attendance,
  /// settings) intentionally highlight nothing.
  static int bottomNavIndex(int branchIndex) => switch (branchIndex) {
        0 || 1 || 2 || 3 => branchIndex,
        _ => -1,
      };

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int? _previousIndex;

  void _goBranch(int index) {
    if (index != widget.navigationShell.currentIndex) {
      _previousIndex = widget.navigationShell.currentIndex;
    }
    widget.navigationShell.goBranch(index);
  }

  void _goBack() {
    final previous = _previousIndex;
    if (previous != null) {
      _previousIndex = null;
      _goBranch(previous);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppNavScope(
      navigationShell: widget.navigationShell,
      goBranch: _goBranch,
      goBack: _goBack,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: widget.navigationShell,
        bottomNavigationBar: AppBottomNavigation(
          items: AppShell._navItems,
          selectedIndex: AppShell.bottomNavIndex(
            widget.navigationShell.currentIndex,
          ),
          onItemSelected: _goBranch,
        ),
      ),
    );
  }
}
