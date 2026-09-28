import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.label,
    this.prefixIcon,
    this.errorText,
    this.helperText,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.onSubmitted,
    this.onChanged,
    this.accentColor = AppColors.primary,
    this.enabled = true,
    this.autofocus = false,
    this.obscureText = false,
    this.suffixIcon,
    this.autofillHints,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final String? label;
  final IconData? prefixIcon;
  final String? errorText;
  final String? helperText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  final Color accentColor;
  final bool enabled;
  final bool autofocus;

  final bool obscureText;
  final Widget? suffixIcon;
  final Iterable<String>? autofillHints;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      obscureText: obscureText,
      autofillHints: autofillHints,
      validator: validator,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary),
        floatingLabelStyle: AppTextStyles.labelLarge.copyWith(
          color: hasError ? AppColors.error : accentColor,
        ),
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        errorText: errorText,
        errorStyle: AppTextStyles.caption.copyWith(color: AppColors.errorDark),
        helperText: helperText,
        helperStyle: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(
                prefixIcon,
                size: 20,
                color: hasError ? AppColors.error : AppColors.textMuted,
              ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.surfaceVariant,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        constraints: const BoxConstraints(minHeight: AppSizes.textFieldHeight),
        enabledBorder: _border(hasError ? AppColors.error : AppColors.border),
        focusedBorder: _border(hasError ? AppColors.error : accentColor, width: 1.5),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error, width: 1.5),
        disabledBorder: _border(AppColors.border),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: color, width: width),
      );
}
