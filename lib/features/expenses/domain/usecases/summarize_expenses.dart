import '../entities/expense.dart';
import '../entities/expense_summary.dart';

class SummarizeExpenses {
  const SummarizeExpenses();

  ExpenseSummary call(List<Expense> expenses) {
    var toReport = 0.0;
    var pending = 0.0;
    var paid = 0.0;

    for (final expense in expenses) {
      switch (expense.status) {
        case ExpenseStatus.toReport:
          toReport += expense.amount;
        case ExpenseStatus.pending:
          pending += expense.amount;
        case ExpenseStatus.paid:
          paid += expense.amount;
      }
    }

    return ExpenseSummary(toReport: toReport, pending: pending, paid: paid);
  }
}
