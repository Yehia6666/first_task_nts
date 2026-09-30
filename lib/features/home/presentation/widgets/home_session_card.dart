import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_status_badge.dart';
import '../../domain/entities/attendance_session.dart';
import 'home_log_history_button.dart';
import 'home_session_row.dart';

/// White card below the check-in card. Header row with "Current Session" and a
/// LOG HISTORY pill that navigates to the attendance logs, plus a few session
/// detail rows.
class HomeSessionCard extends StatelessWidget {
  const HomeSessionCard({
    super.key,
    required this.session,
    required this.onLogHistory,
  });

  final AttendanceSession session;
  final VoidCallback onLogHistory;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: AppRadius.xl,
      padding: const EdgeInsets.all(AppSpacing.xl),
      showShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Current Session', style: AppTextStyles.titleLarge),
              ),
              HomeLogHistoryButton(onTap: onLogHistory),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          HomeSessionRow(
            icon: Icons.schedule_rounded,
            label: 'Checked In',
            value: session.checkInAt == null
                ? 'Not yet'
                : AppFormatters.timeOfDay(session.checkInAt!),
          ),
          const SizedBox(height: AppSpacing.md),
          HomeSessionRow(
            icon: Icons.flag_outlined,
            label: 'Status',
            trailing: AppStatusBadge(
              label: session.status == AttendanceSessionStatus.notCheckedIn
                  ? 'Not Checked In'
                  : 'Present',
              background: session.status == AttendanceSessionStatus.notCheckedIn
                  ? AppColors.warningContainer
                  : AppColors.successContainer,
              foreground: session.status == AttendanceSessionStatus.notCheckedIn
                  ? AppColors.warningDark
                  : AppColors.successDark,
              showDot: true,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          HomeSessionRow(
            icon: Icons.place_outlined,
            label: 'Location',
            value: session.location,
          ),
        ],
      ),
    );
  }
}
