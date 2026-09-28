import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_badge.dart';
import '../../domain/entities/attendance_log.dart';

class AttendanceStatusBadge extends StatelessWidget {
  const AttendanceStatusBadge({super.key, required this.status});

  final AttendanceStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      AttendanceStatus.completed => const AppStatusBadge(
          label: 'Completed',
          background: AppColors.successContainer,
          foreground: AppColors.successDark,
        ),
      AttendanceStatus.pending => const AppStatusBadge(
          label: 'Pending',
          background: AppColors.warningContainer,
          foreground: AppColors.warningDark,
        ),
    };
  }
}
