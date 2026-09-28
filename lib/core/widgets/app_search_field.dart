import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../theme/app_shadows.dart';
import '../theme/app_text_styles.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.background = AppColors.surface,
    this.radius = AppRadius.xl,
    this.height = 48,
    this.showShadow = true,
    this.borderColor,
    this.iconSize = 20,
    this.iconColor = AppColors.textMuted,
    this.hintStyle,
    this.horizontalPadding = AppSpacing.lg,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final Color background;
  final double radius;
  final double height;
  final bool showShadow;
  final Color? borderColor;
  final double iconSize;
  final Color iconColor;
  final TextStyle? hintStyle;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor == null ? null : Border.all(color: borderColor!),
        boxShadow: showShadow ? AppShadows.subtle : null,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle ??
              AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
          prefixIcon: Icon(Icons.search_rounded, size: iconSize, color: iconColor),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }
}
