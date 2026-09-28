import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/widgets/app_header.dart';
import '../../domain/entities/expense.dart';
import '../widgets/expense_detail_hero_card.dart';
import '../widgets/expense_details_info_card.dart';
import '../widgets/expense_notes_card.dart';

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
                  child: ExpenseDetailHeroCard(expense: expense),
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.pagePadding(context),
                  ),
                  child: ExpenseDetailsInfoCard(expense: expense),
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.pagePadding(context),
                  ),
                  child: ExpenseNotesCard(expense: expense),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}