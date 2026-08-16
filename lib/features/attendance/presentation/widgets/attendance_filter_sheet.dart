import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/attendance_filters.dart';

/// Opens the status filter bottom sheet. The chosen option is pushed back via
/// [onStatusSelected] and the sheet is closed by the caller.
Future<void> showAttendanceFilterSheet(
  BuildContext context, {
  required AttendanceStatusFilter selectedStatus,
  required ValueChanged<AttendanceStatusFilter> onStatusSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (_) => AttendanceFilterSheet(
      selectedStatus: selectedStatus,
      onStatusSelected: onStatusSelected,
    ),
  );
}

class AttendanceFilterSheet extends StatelessWidget {
  const AttendanceFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  final AttendanceStatusFilter selectedStatus;
  final ValueChanged<AttendanceStatusFilter> onStatusSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by status', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            for (final option in _options) ...[
              _OptionTile(
                label: option.label,
                selected: selectedStatus == option.value,
                onTap: () => onStatusSelected(option.value),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }

  static const List<({AttendanceStatusFilter value, String label})> _options = [
    (value: AttendanceStatusFilter.all, label: 'All'),
    (value: AttendanceStatusFilter.completed, label: 'Completed'),
    (value: AttendanceStatusFilter.pending, label: 'Pending'),
  ];
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryContainer : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              size: 20,
              color: selected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
