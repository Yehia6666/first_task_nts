import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/attendance_log.dart';
import 'attendance_status_badge.dart';
import 'attendance_type_icon.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({super.key, required this.log});

  final AttendanceLog log;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: AppRadius.card,
      showShadow: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AttendanceTypeIcon(type: log.type),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(log.typeLabel, style: AppTextStyles.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  log.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.bodyMedium,
                ),
                if (log.workedHours != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Worked ${log.workedHours!.toStringAsFixed(2)}h',
                    style: AppTextStyles.captionItalic,
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                AttendanceStatusBadge(status: log.status),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            AppFormatters.timeOfDay(log.time),
            style: AppTextStyles.titleSmall,
          ),
        ],
      ),
    );
  }
}
