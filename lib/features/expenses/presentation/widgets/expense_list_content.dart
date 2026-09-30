import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_state.dart';
import '../../domain/entities/expense.dart';
import '../cubit/expenses_cubit.dart';
import '../states/expenses_state.dart';
import '../widgets/expense_card.dart';

/// State-driven body of the Expenses screen: loading, error, empty and the
/// loaded expense list, all driven by [ExpensesCubit].
class ExpenseListContent extends StatelessWidget {
  const ExpenseListContent({super.key, required this.onOpenDetails});

  final void Function(Expense expense) onOpenDetails;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpensesCubit, ExpensesState>(
      builder: (context, state) {
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
              : _buildList(context, state),
        };
      },
    );
  }

  Widget _buildList(BuildContext context, ExpensesLoaded state) {
    return ListView.separated(
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
    );
  }
}
