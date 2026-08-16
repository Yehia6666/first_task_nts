import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Section header: left expense count, right report creation action label.
class ExpenseSectionHeader extends StatelessWidget {
  const ExpenseSectionHeader({
    super.key,
    required this.expenseCount,
    required this.selectedCount,
  });

  final int expenseCount;
  final int selectedCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$expenseCount EXPENSES',
          style: AppTextStyles.overline.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'CREATE REPORT ($selectedCount)',
          style: AppTextStyles.overline.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}
