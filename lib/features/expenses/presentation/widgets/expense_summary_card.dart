import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/expense_summary.dart';

/// Row of three equal-width summary cards: TO REPORT / PENDING / TOTAL PAID.
class ExpenseSummaryRow extends StatelessWidget {
  const ExpenseSummaryRow({
    super.key,
    required this.summary,
    this.placeholder = false,
  });

  final ExpenseSummary summary;
  final bool placeholder;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ExpenseSummaryCard(
              label: 'To Report',
              amount: placeholder ? '—' : AppFormatters.currency(summary.toReport),
              amountColor: AppColors.accentViolet,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ExpenseSummaryCard(
              label: 'Pending',
              amount: placeholder ? '—' : AppFormatters.currency(summary.pending),
              amountColor: AppColors.warningDark,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ExpenseSummaryCard(
              label: 'Total Paid',
              amount: placeholder ? '—' : AppFormatters.currency(summary.paid),
              amountColor: AppColors.successDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// Single small white summary card with an uppercase label and bold amount.
class ExpenseSummaryCard extends StatelessWidget {
  const ExpenseSummaryCard({
    super.key,
    required this.label,
    required this.amount,
    required this.amountColor,
  });

  final String label;
  final String amount;
  final Color amountColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: AppRadius.xl,
      showShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.overline.copyWith(color: AppColors.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: AppTextStyles.titleLarge.copyWith(color: amountColor),
            ),
          ),
        ],
      ),
    );
  }
}
