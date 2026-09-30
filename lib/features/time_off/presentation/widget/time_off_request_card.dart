import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/time_off_request.dart';
import 'time_off_request_status_badge.dart';

class TimeOffRequestCard extends StatelessWidget {
  const TimeOffRequestCard({super.key, required this.request});

  final TimeOffRequest request;

  String get _dateRange => request.isSingleDay
      ? AppFormatters.shortDate(request.startDate)
      : '${AppFormatters.shortDate(request.startDate)} - '
          '${AppFormatters.shortDate(request.endDate)}';

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: AppRadius.lg,
      showShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  request.type,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                request.duration,
                style: AppTextStyles.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  _dateRange,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ],
          ),
          if (request.note.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              request.note,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          TimeOffRequestStatusBadge(status: request.status),
        ],
      ),
    );
  }
}
