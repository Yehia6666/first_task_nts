import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../domain/entities/expense.dart';
import '../cubit/expenses_cubit.dart';
import '../states/expenses_state.dart';
import 'expense_card.dart';

class ExpensesContent extends StatelessWidget {
  const ExpensesContent({
    super.key,
    required this.state,
    required this.onOpenDetails,
  });

  final ExpensesState state;
  final void Function(Expense expense) onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final ExpensesState state = this.state;
    return switch (state) {
      ExpensesInitial() || ExpensesLoading() => const AppLoadingState(
          message: 'Loading expenses…',
        ),
      ExpensesError() => AppErrorState(
          message: state.message,
          onRetry: () => context.read<ExpensesCubit>().load(),
        ),
      ExpensesLoaded() => state.expenses.isEmpty
          ? const AppEmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No expenses found',
              message: 'Try a different search or tab.',
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              itemCount: state.expenses.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final expense = state.expenses[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppResponsive.pagePadding(context),
                  ),
                  child: ExpenseCard(
                    expense: expense,
                    selected: state.selectedIds.contains(expense.id),
                    onSelected: () =>
                        context.read<ExpensesCubit>().toggleSelection(expense.id),
                    onTap: () => onOpenDetails(expense),
                  ),
                );
              },
            ),
    };
  }
}