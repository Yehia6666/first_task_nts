import '../../domain/entities/expense.dart';
import '../../domain/repository/expense_repository.dart';
import '../datasources/expense_local_data_source.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  const ExpenseRepositoryImpl(this._dataSource);

  final ExpenseLocalDataSource _dataSource;

  @override
  Future<List<Expense>> getExpenses() async {
    final models = await _dataSource.getExpenses();
    return models.map((ExpenseModel m) => m.toEntity()).toList();
  }
}
