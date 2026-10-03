import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_search_field.dart';

/// Expenses search field — white fill, rounded 20, ~48px tall per reference.
class ExpenseSearchField extends StatelessWidget {
  const ExpenseSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppSearchField(
      controller: controller,
      hintText: 'Search expenses...',
      onChanged: onChanged,
      background: AppColors.surface,
      radius: AppRadius.xl,
      prefixIcon: Icons.search_off_rounded,
      height: 48,
      showShadow: true,
      iconSize: 20,
      hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted),
    );
  }
}
