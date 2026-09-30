import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/expense.dart';
import 'expense_icon.dart';
import 'expense_status_badge.dart';

/// Hero card on the expense details screen: category icon, title, status badge
/// and the big amount.
class ExpenseDetailsHeroCard extends StatelessWidget {
  const ExpenseDetailsHeroCard({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      radius: AppRadius.xl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ExpenseIcon(category: expense.category),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: AppTextStyles.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      expense.categoryLabel.toUpperCase(),
                      style: AppTextStyles.overline,
                    ),
                  ],
                ),
              ),
              ExpenseStatusBadge(status: expense.status),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            AppFormatters.currency(expense.amount),
            style: AppTextStyles.displayLarge.copyWith(
              color: AppColors.accentViolet,
            ),
          ),
        ],
      ),
    );
  }
}
