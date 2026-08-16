import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../domain/entities/attendance_filters.dart';

/// Horizontally scrollable pill filter row: All / Check In / Check Out / Filter.
/// The selected pill is dark navy with white text (per reference).
class AttendanceFilterRow extends StatelessWidget {
  const AttendanceFilterRow({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    required this.onFilterTap,
  });

  final AttendanceTypeFilter selectedType;
  final ValueChanged<AttendanceTypeFilter> onTypeSelected;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.filterPillHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppResponsive.pagePadding(context)),
        children: [
          _FilterPill(
            label: 'All',
            selected: selectedType == AttendanceTypeFilter.all,
            onTap: () => onTypeSelected(AttendanceTypeFilter.all),
          ),
          _FilterPill(
            label: 'Check In',
            selected: selectedType == AttendanceTypeFilter.checkIn,
            onTap: () => onTypeSelected(AttendanceTypeFilter.checkIn),
          ),
          _FilterPill(
            label: 'Check Out',
            selected: selectedType == AttendanceTypeFilter.checkOut,
            onTap: () => onTypeSelected(AttendanceTypeFilter.checkOut),
          ),
          _FilterPill(
            label: 'Filter',
            icon: Icons.tune_rounded,
            onTap: onFilterTap,
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.onTap,
    this.icon,
    this.selected = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? AppColors.onPrimary
        : icon != null
            ? AppColors.primary
            : AppColors.textPrimary;
    final borderColor = selected
        ? null
        : icon != null
            ? AppColors.primary
            : AppColors.border;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Material(
        color: selected ? AppColors.textPrimary : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: borderColor == null ? null : Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: foreground),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Text(
                  label,
                  style: AppTextStyles.labelLarge.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
