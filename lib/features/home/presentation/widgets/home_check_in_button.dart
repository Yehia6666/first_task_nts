import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeCheckInButton extends StatelessWidget {
  const HomeCheckInButton({
    super.key,
    required this.isLoading,
    required this.isCheckedIn,
    required this.onPressed,
  });

  final bool isLoading;
  final bool isCheckedIn;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color background = isCheckedIn ? AppColors.successDark : AppColors.success;

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.hero),
        boxShadow: AppShadows.glow(background),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppRadius.hero),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.onPrimary.withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.onPrimary,
                          ),
                        )
                      : Icon(
                          isCheckedIn
                              ? Icons.check_rounded
                              : Icons.exit_to_app_outlined,
                          size: 20,
                          color: AppColors.onPrimary,
                        ),
                ),
                const SizedBox(width: AppSpacing.md),
                Flexible(
                  child: Text(
                    isLoading
                        ? 'Checking In…'
                        : isCheckedIn
                            ? 'Checked In'
                            : 'One Tap Check In',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
