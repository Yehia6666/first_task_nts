import 'package:first_task_nts/core/constants/app_colors.dart';
import 'package:first_task_nts/core/constants/app_radius.dart';
import 'package:first_task_nts/core/constants/app_spacing.dart';
import 'package:first_task_nts/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class RequestAllocationFab extends StatelessWidget {
  const RequestAllocationFab({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.teal,
      borderRadius: BorderRadius.circular(AppRadius.full),
      elevation: 4,
      shadowColor: AppColors.shadow,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_rounded,
                size: 20,
                color: AppColors.onPrimary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Request Allocation',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
