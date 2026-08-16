import '../entities/expense.dart';
import '../entities/expense_tab.dart';

/// Application logic for filtering expenses by tab and search query.
/// Kept outside widgets and the Cubit so it can be reused and unit-tested.
class FilterExpenses {
  const FilterExpenses();

  List<Expense> call({
    required List<Expense> expenses,
    required ExpenseTab tab,
    String query = '',
  }) {
    final normalizedQuery = query.trim().toLowerCase();

    return expenses.where((expense) {
      final matchesTab = switch (tab) {
        ExpenseTab.my => expense.owner == ExpenseOwner.me,
        ExpenseTab.team => expense.owner == ExpenseOwner.team,
      };

      final matchesQuery = normalizedQuery.isEmpty ||
          expense.title.toLowerCase().contains(normalizedQuery) ||
          expense.categoryLabel.toLowerCase().contains(normalizedQuery) ||
          expense.statusLabel.toLowerCase().contains(normalizedQuery);

      return matchesTab && matchesQuery;
    }).toList();
  }
}
