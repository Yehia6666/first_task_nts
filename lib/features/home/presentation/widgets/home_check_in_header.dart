import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../domain/entities/attendance_session.dart';
import 'home_illustration.dart';

class HomeCheckInHeader extends StatelessWidget {
  const HomeCheckInHeader({
    super.key,
    required this.status,
    required this.currentTime,
  });

  final AttendanceSessionStatus status;
  final DateTime currentTime;

  String get _title => switch (status) {
        AttendanceSessionStatus.notCheckedIn => 'Ready to Start?',
        AttendanceSessionStatus.checkedIn => 'You Are Checked In',
        AttendanceSessionStatus.checkedOut => 'Shift Completed',
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const HomeIllustration(),
        const SizedBox(height: AppSpacing.lg),
        Text(
          _title,
          style: AppTextStyles.headline,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          AppFormatters.timeOfDayWithSeconds(currentTime),
          style: AppTextStyles.displayLarge.copyWith(
            color: AppColors.teal,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
