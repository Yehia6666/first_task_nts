import 'package:first_task_nts/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import 'app_drawer_item.dart';
import 'app_logo.dart';
import 'app_nav_scope.dart';

/// Drawer entry: which branch it navigates to plus its icon and label. The
/// branch index matches the [StatefulShellRoute] branch order.
class DrawerEntry {
  const DrawerEntry({
    required this.index,
    required this.icon,
    required this.label,
  });

  final int index;
  final IconData icon;
  final String label;
}

const List<DrawerEntry> _entries = [
  DrawerEntry(index: 0, icon: Icons.home_outlined, label: 'Home'),
  DrawerEntry(index: 1, icon: Icons.event_note_outlined, label: 'Time Off'),
  DrawerEntry(
    index: 2,
    icon: Icons.account_balance_wallet_outlined,
    label: 'Payroll',
  ),
  DrawerEntry(index: 3, icon: Icons.receipt_long_outlined, label: 'Expense'),
  DrawerEntry(
    index: 4,
    icon: Icons.calendar_month_outlined,
    label: 'Attendance',
  ),
  DrawerEntry(index: 5, icon: Icons.settings_outlined, label: 'Settings'),
];

/// Application drawer opened from any screen with a menu/hamburger button
/// (Home, Expenses). The selected item reflects the active [StatefulShellRoute]
/// branch, and tapping an item delegates navigation to the shell via
/// [AppNavScope].
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.sizeOf(context).width * 0.75).clamp(0.0, 360.0);
    final scope = AppNavScope.of(context);
    final currentIndex = scope.navigationShell.currentIndex;

    return Drawer(
      width: width,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(AppRadius.xl),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const AppLogo( height: 36 , width: 36,),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Massary',style: AppTextStyles.headline,)
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              const Divider(height: 1, thickness: 1, color: AppColors.border),
              const SizedBox(height: AppSpacing.sm),
              Flexible(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  children: [
                    for (final entry in _entries)
                      AppDrawerItem(
                        icon: entry.icon,
                        label: entry.label,
                        selected: currentIndex == entry.index,
                        onTap: () {
                          scope.goBranch(entry.index);
                          Navigator.of(context).pop();
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
