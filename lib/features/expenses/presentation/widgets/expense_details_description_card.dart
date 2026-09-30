import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/expense.dart';

/// Notes card at the bottom of the expense details screen.
class ExpenseDetailsDescriptionCard extends StatelessWidget {
  const ExpenseDetailsDescriptionCard({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('NOTES', style: AppTextStyles.overline),
          const SizedBox(height: AppSpacing.sm),
          Text(
            expense.description.isEmpty
                ? 'No notes for this expense.'
                : expense.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
