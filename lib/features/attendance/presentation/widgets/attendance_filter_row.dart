import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../domain/entities/attendance_filters.dart';
import 'attendance_filter_pill.dart';

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
          AttendanceFilterPill(
            label: 'All',
            selected: selectedType == AttendanceTypeFilter.all,
            onTap: () => onTypeSelected(AttendanceTypeFilter.all),
          ),
          AttendanceFilterPill(
            label: 'Check In',
            selected: selectedType == AttendanceTypeFilter.checkIn,
            onTap: () => onTypeSelected(AttendanceTypeFilter.checkIn),
          ),
          AttendanceFilterPill(
            label: 'Check Out',
            selected: selectedType == AttendanceTypeFilter.checkOut,
            onTap: () => onTypeSelected(AttendanceTypeFilter.checkOut),
          ),
          AttendanceFilterPill(
            label: 'Filter',
            icon: Icons.tune_rounded,
            onTap: onFilterTap,
          ),
        ],
      ),
    );
  }
}
