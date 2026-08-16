import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_floating_action_button.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_summary.dart';
import '../../domain/entities/expense_tab.dart';
import '../cubit/expenses_cubit.dart';
import '../states/expenses_state.dart';
import '../widgets/expense_card.dart';
import '../widgets/expense_search_field.dart';
import '../widgets/expense_section_header.dart';
import '../widgets/expense_summary_card.dart';
import '../widgets/expense_tabs.dart';
import '../widgets/expenses_header.dart';
import 'expense_details_screen.dart';

/// Mobile-first Expenses screen. Header, summary cards, search, tabs and a
/// vertical expense list, all driven by [ExpensesCubit].
class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFabPressed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create report coming soon')),
    );
  }

  void _openDetails(BuildContext context, Expense expense) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExpenseDetailsScreen(expense: expense),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      floatingActionButton: AppFloatingActionButton(
        onPressed: () => _onFabPressed(context),
        icon: Icons.add_rounded,
        tooltip: 'Create report',
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: BlocBuilder<ExpensesCubit, ExpensesState>(
          builder: (context, state) {
            final isLoaded = state is ExpensesLoaded;
            final summary = isLoaded
                ? state.summary
                : ExpenseSummary.empty;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: AppSpacing.sm),
                      child: ExpensesHeader(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.pagePadding(context),
                      ),
                      child: ExpenseSummaryRow(
                        summary: summary,
                        placeholder: !isLoaded,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.pagePadding(context),
                      ),
                      child: ExpenseSearchField(
                        controller: _searchController,
                        onChanged: (query) =>
                            context.read<ExpensesCubit>().onSearchChanged(query),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.pagePadding(context),
                      ),
                      child: ExpenseTabs(
                        selectedTab:
                            isLoaded ? state.tab : ExpenseTab.my,
                        onChanged: (tab) =>
                            context.read<ExpensesCubit>().onTabChanged(tab),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.pagePadding(context),
                      ),
                      child: ExpenseSectionHeader(
                        expenseCount: isLoaded ? state.expenses.length : 0,
                        selectedCount:
                            isLoaded ? state.selectedIds.length : 0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Expanded(child: _buildContent(state)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(ExpensesState state) {
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
                    onTap: () => _openDetails(context, expense),
                  ),
                );
              },
            ),
    };
  }
}
