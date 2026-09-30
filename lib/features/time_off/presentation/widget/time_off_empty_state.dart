import 'package:first_task_nts/core/constants/app_colors.dart';
import 'package:first_task_nts/core/constants/app_radius.dart';
import 'package:first_task_nts/core/constants/app_spacing.dart';
import 'package:first_task_nts/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class TimeOffEmptyState extends StatelessWidget {
  const TimeOffEmptyState({
    super.key,
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  static const double _boxSize = 64;
  static const double _iconSize = 32;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _boxSize,
              height: _boxSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(icon, size: _iconSize, color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
