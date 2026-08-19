import 'package:first_task_nts/features/time_off/presentation/screen/time_off_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_colors.dart';
import 'core/navigation/app_nav_cubit.dart';
import 'core/widgets/app_bottom_navigation.dart';
import 'core/widgets/app_placeholder_screen.dart';
import 'features/attendance/presentation/screens/attendance_logs_screen.dart';
import 'features/expenses/presentation/screens/expenses_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';

/// App-level navigation shell. Owns the destination stack and the bottom
/// navigation bar; both read the current destination from [AppNavCubit], which
/// is the single source of truth for what screen is shown.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const List<AppBottomNavItem> _navItems = [
    AppBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
    AppBottomNavItem(icon: Icons.event_note_outlined, label: 'Time Off'),
    AppBottomNavItem(icon: Icons.account_balance_wallet_outlined, label: 'Payroll'),
    AppBottomNavItem(icon: Icons.receipt_long_outlined, label: 'Expense'),
  ];

  /// Bottom-nav index for a destination; drawer-only destinations (attendance,
  /// settings) intentionally highlight nothing.
  static int _bottomNavIndex(AppDestination destination) => switch (destination) {
        AppDestination.home => 0,
        AppDestination.timeOff => 1,
        AppDestination.payroll => 2,
        AppDestination.expense => 3,
        _ => -1,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<AppNavCubit, AppDestination>(
        builder: (context, destination) => IndexedStack(
          index: destination.index,
          children: const [
            HomeScreen(),
           TimeOffScreen(),
            PlaceholderScreen(
              title: 'Payroll',
              icon: Icons.account_balance_wallet_outlined,
              message: 'Payroll details will live here.',
            ),
            ExpensesScreen(),
            AttendanceLogsScreen(),
            PlaceholderScreen(
              title: 'Settings',
              icon: Icons.settings_outlined,
              message: 'App settings will live here.',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<AppNavCubit, AppDestination>(
        builder: (context, destination) => AppBottomNavigation(
          items: _navItems,
          selectedIndex: _bottomNavIndex(destination),
          onItemSelected: (index) =>
              context.read<AppNavCubit>().select(AppDestination.values[index]),
        ),
      ),
    );
  }
}
