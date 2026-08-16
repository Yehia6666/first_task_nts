import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/attendance_log.dart';

/// Rounded icon container for check in / check out.
/// Check In → mint background + green icon; Check Out → pink background + red icon.
class AttendanceTypeIcon extends StatelessWidget {
  const AttendanceTypeIcon({super.key, required this.type});

  final AttendanceType type;

  @override
  Widget build(BuildContext context) {
    final isCheckIn = type == AttendanceType.checkIn;

    return Container(
      width: AppSizes.typeIconSize,
      height: AppSizes.typeIconSize,
      decoration: BoxDecoration(
        color: isCheckIn ? AppColors.successContainer : AppColors.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Icon(
        isCheckIn ? Icons.login_rounded : Icons.logout_rounded,
        size: 28,
        color: isCheckIn ? AppColors.success : AppColors.error,
      ),
    );
  }
}
