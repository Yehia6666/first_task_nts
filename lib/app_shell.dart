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
import 'features/payroll/presentation/screen/payroll_screen.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const List<AppBottomNavItem> _navItems = [
    AppBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
    AppBottomNavItem(icon: Icons.event_note_outlined, label: 'Time Off'),
    AppBottomNavItem(icon: Icons.account_balance_wallet_outlined, label: 'Payroll'),
    AppBottomNavItem(icon: Icons.receipt_long_outlined, label: 'Expense'),
  ];

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
        builder: (context, destination) =>
            _AppDestinationStack(destination: destination),
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

/// Keeps every visited destination alive so its state survives switching, but
/// only builds a destination the first time it is selected. A plain
/// [IndexedStack] builds all of its children on the first frame, which is what
/// delayed the first painted frame on startup.
class _AppDestinationStack extends StatefulWidget {
  const _AppDestinationStack({required this.destination});

  final AppDestination destination;

  @override
  State<_AppDestinationStack> createState() => _AppDestinationStackState();
}

class _AppDestinationStackState extends State<_AppDestinationStack> {
  final Set<AppDestination> _visited = {AppDestination.home};

  static const List<Widget> _screens = [
    HomeScreen(),
    TimeOffScreen(),
    PayrollScreen(),
    ExpensesScreen(),
    AttendanceLogsScreen(),
    PlaceholderScreen(
      title: 'Settings',
      icon: Icons.settings_outlined,
      message: 'App settings will live here.',
    ),
  ];

  @override
  void didUpdateWidget(covariant _AppDestinationStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_visited.contains(widget.destination)) {
      setState(() => _visited.add(widget.destination));
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.destination.index,
      children: [
        for (final destination in AppDestination.values)
          if (_visited.contains(destination)) _screens[destination.index]
          else const SizedBox.shrink(),
      ],
    );
  }
}
