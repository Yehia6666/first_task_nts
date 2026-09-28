import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.enabled = true,
    this.expanded = true,
    this.height = 48,
    this.backgroundColor,
    this.pressedBackgroundColor,
    this.foregroundColor,
    this.borderRadius = AppRadius.md,
    this.labelStyle,
    this.loadingIndicatorSize = 20,
    this.loadingColor,
  });

  final String label;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final IconData? icon;

  final IconData? trailingIcon;

  final bool loading;

  final bool enabled;
  final bool expanded;
  final double height;

  final Color? backgroundColor;
  final Color? pressedBackgroundColor;

  final Color? foregroundColor;

  final double borderRadius;
  final TextStyle? labelStyle;
  final double loadingIndicatorSize;
  final Color? loadingColor;

  @override
  Widget build(BuildContext context) {
    final bool isActive = enabled && !loading;
    final TextStyle textStyle = labelStyle ?? AppTextStyles.labelLarge;

    final content = loading
        ? SizedBox(
            width: loadingIndicatorSize,
            height: loadingIndicatorSize,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: loadingColor ?? _foreground(isActive: isActive),
            ),
          )
        : Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: _foreground(isActive: isActive)),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle.copyWith(
                    color: _foreground(isActive: isActive),
                  ),
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(
                  trailingIcon,
                  size: 20,
                  color: _foreground(isActive: isActive),
                ),
              ],
            ],
          );

    final VoidCallback handler = isActive ? onPressed : () {};

    return SizedBox(
      height: height,
      child: switch (variant) {
        AppButtonVariant.primary => FilledButton(
            onPressed: handler,
            style: FilledButton.styleFrom(
              foregroundColor: foregroundColor ?? AppColors.onPrimary,
              disabledBackgroundColor: AppColors.surfaceVariant,
              disabledForegroundColor: AppColors.textMuted,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ).copyWith(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return AppColors.surfaceVariant;
                }
                if (states.contains(WidgetState.pressed)) {
                  return pressedBackgroundColor ?? AppColors.primaryDark;
                }
                return backgroundColor ?? AppColors.primary;
              }),
            ),
            child: content,
          ),
        AppButtonVariant.secondary => OutlinedButton(
            onPressed: handler,
            style: OutlinedButton.styleFrom(
              foregroundColor: foregroundColor ?? AppColors.textPrimary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: content,
          ),
        AppButtonVariant.text => TextButton(
            onPressed: handler,
            style: TextButton.styleFrom(
              foregroundColor: foregroundColor ?? AppColors.primary,
              disabledForegroundColor: AppColors.textMuted,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: content,
          ),
      },
    );
  }

  Color _foreground({required bool isActive}) {
    if (!isActive) return AppColors.textMuted;
    return foregroundColor ??
        switch (variant) {
          AppButtonVariant.primary => AppColors.onPrimary,
          AppButtonVariant.secondary => AppColors.textPrimary,
          AppButtonVariant.text => AppColors.primary,
        };
  }
}
