import '../entities/expense.dart';

/// Repository contract. The presentation layer depends on this abstraction,
/// never on the concrete data source.
abstract class ExpenseRepository {
  Future<List<Expense>> getExpenses();
}
