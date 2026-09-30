import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../domain/entities/attendance_session.dart';
import 'home_elapsed_box.dart';
import 'home_time_block.dart';

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
          child: HomeTimeBlock(
            label: 'EARLIEST EVENT',
            time: AppFormatters.timeOfDay(session.earliestEvent),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        HomeElapsedBox(percent: (progress * 100).round()),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: HomeTimeBlock(
            label: 'TARGET END',
            time: AppFormatters.timeOfDay(session.targetEnd),
            alignEnd: true,
          ),
        ),
      ],
    );
  }
}
