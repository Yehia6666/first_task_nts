import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../navigation/app_nav_cubit.dart';
import '../theme/app_text_styles.dart';

const double _drawerLogoSize = 40;

class _DrawerEntry {
  const _DrawerEntry({
    required this.icon,
    required this.label,
    this.destination,
  });

  final AppDestination? destination;
  final IconData icon;
  final String label;
}

const List<_DrawerEntry> _entries = [
  _DrawerEntry(
    destination: AppDestination.home,
    icon: Icons.home_outlined,
    label: 'Home',
  ),
  _DrawerEntry(
    destination: AppDestination.timeOff,
    icon: Icons.event_note_outlined,
    label: 'Time Off',
  ),
  _DrawerEntry(
    destination: AppDestination.payroll,
    icon: Icons.account_balance_wallet_outlined,
    label: 'Payroll',
  ),
  _DrawerEntry(
    destination: AppDestination.expense,
    icon: Icons.receipt_long_outlined,
    label: 'Expense',
  ),
  _DrawerEntry(
    destination: AppDestination.attendance,
    icon: Icons.schedule_outlined,
    label: 'Attendance',
  ),
  _DrawerEntry(
    icon: Icons.inbox_outlined,
    label: 'Approval Requests',
  ),
  _DrawerEntry(
    destination: AppDestination.settings,
    icon: Icons.settings_outlined,
    label: 'Settings',
  ),
];

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.sizeOf(context).width * 0.75).clamp(0.0, 360.0);
    final destination = context.watch<AppNavCubit>().state;

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(_drawerLogoSize * 0.3),
                    child: Image.asset(
                      'assets/images/logo.jpeg',
                      width: _drawerLogoSize,
                      height: _drawerLogoSize,
                      fit: BoxFit.cover,
                      semanticLabel: 'App logo',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Masary',
                    style: AppTextStyles.titleLarge
                        .copyWith(fontWeight: FontWeight.w800),
                  ),
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
                      _DrawerItem(
                        entry: entry,
                        selected:
                            entry.destination != null &&
                                destination == entry.destination,
                        onTap: () {
                          final target = entry.destination;
                          if (target != null) {
                            context.read<AppNavCubit>().select(target);
                          }
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

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.entry,
    required this.selected,
    required this.onTap,
  });

  final _DrawerEntry entry;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? AppColors.teal : AppColors.textMuted;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: selected ? AppColors.tealContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Icon(entry.icon, size: 22, color: color),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    entry.label,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: color,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
