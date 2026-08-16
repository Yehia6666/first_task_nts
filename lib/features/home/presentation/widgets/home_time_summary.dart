import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../domain/entities/attendance_session.dart';

/// Three-part time summary inside the check-in card:
/// earliest event (left) · elapsed box (center) · target end (right).
class HomeTimeSummary extends StatelessWidget {
  const HomeTimeSummary({
    super.key,
    required this.session,
    required this.progress,
  });

  final AttendanceSession session;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _TimeBlock(
            label: 'EARLIEST EVENT',
            time: AppFormatters.timeOfDay(session.earliestEvent),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        _ElapsedBox(percent: (progress * 100).round()),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _TimeBlock(
            label: 'TARGET END',
            time: AppFormatters.timeOfDay(session.targetEnd),
            alignEnd: true,
          ),
        ),
      ],
    );
  }
}

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({
    required this.label,
    required this.time,
    this.alignEnd = false,
  });

  final String label;
  final String time;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final crossAlignment =
        alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: crossAlignment,
      children: [
        Text(
          label,
          style: AppTextStyles.overline,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          time,
          style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

/// Rounded mint box with the elapsed percentage, success pair coloring.
class _ElapsedBox extends StatelessWidget {
  const _ElapsedBox({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.successContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Column(
        children: [
          Text(
            'ELAPSED',
            style: AppTextStyles.overline.copyWith(
              color: AppColors.successDark,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '$percent%',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
