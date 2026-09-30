import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/expense.dart';
import 'expense_detail_tile.dart';

/// Card listing the key expense facts (category, date, merchant, payment
/// method, reference) on the expense details screen.
class ExpenseDetailsInfoCard extends StatelessWidget {
  const ExpenseDetailsInfoCard({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          children: [
            ExpenseDetailTile(
              label: 'Category',
              value: expense.categoryLabel,
              icon: Icons.category_outlined,
            ),
            ExpenseDetailTile(
              label: 'Date',
              value: AppFormatters.day(expense.date),
              icon: Icons.calendar_today_outlined,
            ),
            ExpenseDetailTile(
              label: 'Merchant',
              value: expense.merchant.isEmpty ? '—' : expense.merchant,
              icon: Icons.store_outlined,
            ),
            ExpenseDetailTile(
              label: 'Paid via',
              value: expense.paymentMethodLabel,
              icon: Icons.payments_outlined,
            ),
            ExpenseDetailTile(
              label: 'Reference',
              value: expense.receiptRef.isEmpty ? '—' : expense.receiptRef,
              icon: Icons.receipt_outlined,
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }
}
