import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/attendance_session.dart';
import 'home_check_in_button.dart';
import 'home_illustration.dart';
import 'home_time_summary.dart';

class HomeCheckInCard extends StatelessWidget {
  const HomeCheckInCard({
    super.key,
    required this.session,
    required this.currentTime,
    required this.progress,
    required this.isCheckingIn,
    required this.onCheckIn,
  });

  final AttendanceSession session;
  final DateTime currentTime;
  final double progress;
  final bool isCheckingIn;
  final VoidCallback onCheckIn;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: AppRadius.hero,
      padding: const EdgeInsets.all(AppSpacing.xl),
      showBorder: false,
      showShadow: true,
      child: Column(
        children: [
          const HomeIllustration(),
          const SizedBox(height: AppSpacing.lg),
          Text('Ready to Start?', style: AppTextStyles.headline),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppFormatters.timeOfDayWithSeconds(currentTime),
            style: AppTextStyles.displayLarge.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          HomeTimeSummary(session: session, progress: progress),
          const SizedBox(height: AppSpacing.xl),
          _ProgressBar(progress: progress),
          const SizedBox(height: AppSpacing.xl),
          HomeCheckInButton(
            isLoading: isCheckingIn,
            isCheckedIn: session.status != AttendanceSessionStatus.notCheckedIn,
            onPressed: onCheckIn,
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
