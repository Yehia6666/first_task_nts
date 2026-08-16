import '../../domain/entities/expense.dart';
import '../../domain/repository/expense_repository.dart';
import '../datasources/expense_local_data_source.dart';
import '../models/expense_model.dart';

/// Implements the domain contract. UI never depends on this class directly;
/// swap the data source here when a real API is added.
class ExpenseRepositoryImpl implements ExpenseRepository {
  const ExpenseRepositoryImpl(this._dataSource);

  final ExpenseLocalDataSource _dataSource;

  @override
  Future<List<Expense>> getExpenses() async {
    final models = await _dataSource.getExpenses();
    return models.map((ExpenseModel m) => m.toEntity()).toList();
  }
}
