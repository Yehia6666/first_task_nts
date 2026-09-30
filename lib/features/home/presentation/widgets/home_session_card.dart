import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_status_badge.dart';
import '../../domain/entities/attendance_session.dart';
import 'session_row.dart';

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
    final bool hasSession =
        session.status != AttendanceSessionStatus.notCheckedIn;

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
              _LogHistoryButton(onTap: onLogHistory),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          if (!hasSession)
            const SessionRow(
              icon: Icons.schedule_rounded,
              label: 'No Active Session',
            )
          else ...[
            SessionRow(
              icon: Icons.schedule_rounded,
              label: 'Checked In',
              value: session.checkInAt == null
                  ? 'Not yet'
                  : AppFormatters.timeOfDay(session.checkInAt!),
            ),
            const SizedBox(height: AppSpacing.md),
            SessionRow(
              icon: Icons.flag_outlined,
              label: 'Status',
              trailing: AppStatusBadge(
                label: session.status == AttendanceSessionStatus.checkedOut
                    ? 'Completed'
                    : 'Present',
                background: session.status == AttendanceSessionStatus.checkedOut
                    ? AppColors.primaryContainer
                    : AppColors.successContainer,
                foreground: session.status == AttendanceSessionStatus.checkedOut
                    ? AppColors.primary
                    : AppColors.successDark,
                showDot: true,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SessionRow(
              icon: Icons.place_outlined,
              label: 'Location',
              value: session.location,
            ),
          ],
        ],
      ),
    );
  }
}

class _LogHistoryButton extends StatelessWidget {
  const _LogHistoryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceVariant,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'LOG HISTORY',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}