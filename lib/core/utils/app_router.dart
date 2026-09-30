import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/attendance/presentation/screens/attendance_logs_screen.dart';
import '../../features/expenses/domain/entities/expense.dart';
import '../../features/expenses/presentation/screens/expense_details_screen.dart';
import '../../features/expenses/presentation/screens/expenses_screen.dart';
import '../../features/home/presentation/view/home_screen.dart';
import '../../features/profile/presentation/screen/profile_screen.dart';
import '../../features/time_off/presentation/screen/time_off_screen.dart';
import '../widgets/app_placeholder_screen.dart';
import '../widgets/app_shell.dart';

abstract class AppRouter {
  static const String home = '/';
  static const String timeOff = '/time-off';
  static const String payroll = '/payroll';
  static const String expense = '/expense';
  static const String attendance = '/attendance';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String expenseDetails = '/expense-details';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: timeOff,
                name: 'timeOff',
                builder: (context, state) => const TimeOffScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: payroll,
                name: 'payroll',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Payroll',
                  icon: Icons.account_balance_wallet_outlined,
                  message: 'Payroll details will live here.',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: expense,
                name: 'expense',
                builder: (context, state) => const ExpensesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: attendance,
                name: 'attendance',
                builder: (context, state) => const AttendanceLogsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: settings,
                name: 'settings',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Settings',
                  icon: Icons.settings_outlined,
                  message: 'App settings will live here.',
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: expenseDetails,
        name: 'expenseDetails',
        builder: (context, state) =>
            ExpenseDetailsScreen(expense: state.extra as Expense),
      ),
    ],
  );
}
