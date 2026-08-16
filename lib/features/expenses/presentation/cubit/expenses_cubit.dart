import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_tab.dart';
import '../../domain/usecases/filter_expenses.dart';
import '../../domain/usecases/get_expenses.dart';
import '../../domain/usecases/summarize_expenses.dart';
import '../states/expenses_state.dart';

/// Holds expense state, delegates business logic to use cases, and emits
/// states the UI renders. Contains no layout/widget code.
class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit({
    required this.getExpenses,
    required this.filterExpenses,
    required this.summarizeExpenses,
  }) : super(const ExpensesInitial()) {
    load();
  }

  final GetExpenses getExpenses;
  final FilterExpenses filterExpenses;
  final SummarizeExpenses summarizeExpenses;

  List<Expense> _allExpenses = const [];
  ExpenseTab _tab = ExpenseTab.my;
  String _searchQuery = '';
  final Set<String> _selectedIds = {};

  Future<void> load() async {
    emit(const ExpensesLoading());
    try {
      _allExpenses = await getExpenses();
      _emitFiltered();
    } catch (_) {
      emit(const ExpensesError(
        'We could not load your expenses. Please try again.',
      ));
    }
  }

  void onTabChanged(ExpenseTab tab) {
    if (tab == _tab) return;
    _tab = tab;
    _selectedIds.clear();
    _emitFiltered();
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _emitFiltered();
  }

  void toggleSelection(String id) {
    if (!_selectedIds.add(id)) {
      _selectedIds.remove(id);
    }
    _emitFiltered();
  }

  void clearSelection() {
    if (_selectedIds.isEmpty) return;
    _selectedIds.clear();
    _emitFiltered();
  }

  void _emitFiltered() {
    final filtered = filterExpenses(
      expenses: _allExpenses,
      tab: _tab,
      query: _searchQuery,
    );
    final summary = summarizeExpenses(filtered);

    emit(ExpensesLoaded(
      expenses: filtered,
      summary: summary,
      tab: _tab,
      searchQuery: _searchQuery,
      selectedIds: Set.of(_selectedIds),
    ));
  }
}
