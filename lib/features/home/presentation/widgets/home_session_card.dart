import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_status_badge.dart';
import '../../domain/entities/attendance_session.dart';

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
              _LogHistoryButton(onTap: onLogHistory),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _SessionRow(
            icon: Icons.schedule_rounded,
            label: 'Checked In',
            value: session.checkInAt == null
                ? 'Not yet'
                : AppFormatters.timeOfDay(session.checkInAt!),
          ),
          const SizedBox(height: AppSpacing.md),
          _SessionRow(
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
          _SessionRow(
            icon: Icons.place_outlined,
            label: 'Location',
            value: session.location,
          ),
        ],
      ),
    );
  }
}

/// Rounded light pill button used for the LOG HISTORY action.
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

/// Single detail row: tinted icon circle, muted label, and a value or a
/// trailing widget (e.g. the status badge).
class _SessionRow extends StatelessWidget {
  const _SessionRow({
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.surfaceVariant,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 20, color: AppColors.textSecondary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodyMedium),
              const SizedBox(height: AppSpacing.xs),
              if (trailing != null)
                trailing!
              else
                Text(
                  value ?? '—',
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
