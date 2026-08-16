import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, text }

/// Reusable button following the design system. Height 48 for full-size
/// actions, 36 for compact ones.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.expanded = true,
    this.height = 48,
  });

  final String label;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool expanded;
  final double height;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: _foreground),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelLarge.copyWith(color: _foreground),
          ),
        ),
      ],
    );

    return SizedBox(
      height: height,
      child: switch (variant) {
        AppButtonVariant.primary => FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              disabledBackgroundColor: AppColors.surfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: content,
          ),
        AppButtonVariant.secondary => OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: content,
          ),
        AppButtonVariant.text => TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: content,
          ),
      },
    );
  }

  Color get _foreground => switch (variant) {
        AppButtonVariant.primary => AppColors.onPrimary,
        AppButtonVariant.secondary => AppColors.textPrimary,
        AppButtonVariant.text => AppColors.primary,
      };
}
