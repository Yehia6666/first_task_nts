import '../entities/expense.dart';
import '../repository/expense_repository.dart';

/// Loads all expenses through the repository abstraction.
class GetExpenses {
  const GetExpenses(this._repository);

  final ExpenseRepository _repository;

  Future<List<Expense>> call() => _repository.getExpenses();
}
