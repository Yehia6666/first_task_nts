import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../theme/app_shadows.dart';
import '../theme/app_text_styles.dart';

/// Reusable search field. Defaults match the Expense reference: white surface
/// background, large rounded corners, ~48px height, very subtle shadow, no
/// visible border, and a muted gray leading search icon + hint. All visual
/// properties are exposed as optional parameters so screens can deviate while
/// staying on design-system tokens.
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmit,
    this.background = AppColors.surface,
    this.radius = AppRadius.xl,
    this.height = 48,
    this.showShadow = true,
    this.borderColor = AppColors.textMuted,
    this.iconSize = 20,
    this.iconColor = AppColors.textMuted,
    this.hintStyle,
    this.prefixIcon,
    this.validator,
    this.horizontalPadding = AppSpacing.lg,
    this.suffixIcon,
    this.isObsecure = false ,
  });

  final TextEditingController? controller;
  final String hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final Color background;
  final double radius;
  final double height;
  final bool showShadow;
  final Color? borderColor;
  final double iconSize;
  final Color iconColor;
  final TextStyle? hintStyle;
  final double horizontalPadding;
  final IconData? prefixIcon;
  final FormFieldValidator<String>? validator;
  final IconButton? suffixIcon;
  final bool? isObsecure ;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        // border: borderColor == null ? null : Border.all(color: borderColor!),
        boxShadow: showShadow ? AppShadows.subtle : null,
      ),
      child: SizedBox(
        height: height,
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          onFieldSubmitted: onSubmit,
          validator: validator,
          obscureText: isObsecure!,
          textAlignVertical: TextAlignVertical.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                hintStyle ??
                AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
            prefixIcon: Icon(
              prefixIcon ?? Icons.search,
              size: iconSize,
              color: iconColor,
            ),
            suffixIcon: suffixIcon,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
            filled: true,
            fillColor: background,
            contentPadding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: borderColor == null
                  ? BorderSide.none
                  : BorderSide(color: borderColor!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: borderColor ?? AppColors.primary),
            ),
          ),
        ),
      ),
    );
  }
}
