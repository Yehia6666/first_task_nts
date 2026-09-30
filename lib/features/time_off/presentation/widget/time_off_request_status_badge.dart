import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_badge.dart';
import '../../domain/entities/time_off_request.dart';

class TimeOffRequestStatusBadge extends StatelessWidget {
  const TimeOffRequestStatusBadge({super.key, required this.status});

  final TimeOffRequestStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      TimeOffRequestStatus.approved => const AppStatusBadge(
          label: 'APPROVED',
          background: AppColors.successContainer,
          foreground: AppColors.successDark,
          showDot: true,
        ),
      TimeOffRequestStatus.pending => const AppStatusBadge(
          label: 'PENDING',
          background: AppColors.warningContainer,
          foreground: AppColors.warningDark,
          showDot: true,
        ),
      TimeOffRequestStatus.rejected => const AppStatusBadge(
          label: 'REJECTED',
          background: AppColors.errorContainer,
          foreground: AppColors.errorDark,
          showDot: true,
        ),
    };
  }
}
