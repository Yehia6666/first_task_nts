import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_header.dart';
import '../../domain/entities/expense.dart';
import '../widgets/expense_detail_tile.dart';
import '../widgets/expense_icon.dart';
import '../widgets/expense_status_badge.dart';

/// Full detail view for a single expense, reached by tapping an [ExpenseCard].
class ExpenseDetailsScreen extends StatelessWidget {
  const ExpenseDetailsScreen({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              children: [
                AppHeader(
                  title: 'Expense Details',
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Back',
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      size: 24,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.pagePadding(context),
                  ),
                  child: _buildHeroCard(context),
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.pagePadding(context),
                  ),
                  child: _buildDetailsCard(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.pagePadding(context),
                  ),
                  child: _buildDescriptionCard(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
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

  Widget _buildDetailsCard() {
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

  Widget _buildDescriptionCard() {
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
