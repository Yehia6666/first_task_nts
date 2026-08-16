import 'package:equatable/equatable.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_summary.dart';
import '../../domain/entities/expense_tab.dart';

sealed class ExpensesState extends Equatable {
  const ExpensesState();
}

class ExpensesInitial extends ExpensesState {
  const ExpensesInitial();

  @override
  List<Object?> get props => [];
}

class ExpensesLoading extends ExpensesState {
  const ExpensesLoading();

  @override
  List<Object?> get props => [];
}

class ExpensesLoaded extends ExpensesState {
  const ExpensesLoaded({
    required this.expenses,
    required this.summary,
    required this.tab,
    required this.searchQuery,
    required this.selectedIds,
  });

  final List<Expense> expenses;
  final ExpenseSummary summary;
  final ExpenseTab tab;
  final String searchQuery;
  final Set<String> selectedIds;

  @override
  List<Object?> get props => [
        expenses,
        summary,
        tab,
        searchQuery,
        selectedIds,
      ];
}

class ExpensesError extends ExpensesState {
  const ExpensesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
