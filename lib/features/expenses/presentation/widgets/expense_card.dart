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

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    super.key,
    required this.expense,
    required this.selected,
    required this.onSelected,
    this.onTap,
  });

  final Expense expense;
  final bool selected;
  final VoidCallback onSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: AppRadius.xl,
      showShadow: true,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      onTap: onTap,
      child: Row(
        children: [
          Checkbox(
            value: selected,
            onChanged: (_) => onSelected(),
            activeColor: AppColors.primary,
            shape: const CircleBorder(),
            side: const BorderSide(color: AppColors.border, width: 1.5),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: AppSpacing.xs),
          ExpenseIcon(category: expense.category),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: AppTextStyles.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${expense.categoryLabel.toUpperCase()}  •  '
                  '${AppFormatters.shortDate(expense.date)}',
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppFormatters.currency(expense.amount),
                style: AppTextStyles.titleSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              ExpenseStatusBadge(status: expense.status),
            ],
          ),
        ],
      ),
    );
  }
}
