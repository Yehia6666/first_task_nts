import '../../domain/entities/expense.dart';
import '../models/expense_model.dart';

class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getExpenses() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _buildMockExpenses();
  }

  List<ExpenseModel> _buildMockExpenses() {
    DateTime on(int month, int day) => DateTime(2026, month, day);

    return [
      ExpenseModel(
        id: 'exp-1',
        title: 'Team lunch',
        category: ExpenseCategory.meals,
        date: on(8, 1),
        amount: 45.00,
        status: ExpenseStatus.toReport,
        owner: ExpenseOwner.me,
        description:
            'Team lunch at an Italian restaurant after the weekly '
            'sync to celebrate the demo milestone.',
        merchant: 'La Trattoria, Downtown Cairo',
        paymentMethod: PaymentMethod.card,
        receiptRef: 'RCP-2026-0831',
      ),
      ExpenseModel(
        id: 'exp-2',
        title: 'Client taxi',
        category: ExpenseCategory.mileage,
        date: on(7, 30),
        amount: 18.50,
        status: ExpenseStatus.pending,
        owner: ExpenseOwner.me,
        description:
            'Taxi ride to the client\'s office for the project '
            'kickoff meeting.',
        merchant: 'Uber',
        paymentMethod: PaymentMethod.card,
        receiptRef: 'RCP-2026-0730',
      ),
      ExpenseModel(
        id: 'exp-3',
        title: 'Hotel – Cairo',
        category: ExpenseCategory.travel,
        date: on(7, 22),
        amount: 120.00,
        status: ExpenseStatus.paid,
        owner: ExpenseOwner.me,
        description: 'One-night stay in Cairo for the on-site client visit.',
        merchant: 'Hilton Cairo',
        paymentMethod: PaymentMethod.online,
        receiptRef: 'INV-2026-0722',
      ),
      ExpenseModel(
        id: 'exp-4',
        title: 'Team snacks',
        category: ExpenseCategory.meals,
        date: on(7, 28),
        amount: 32.00,
        status: ExpenseStatus.toReport,
        owner: ExpenseOwner.team,
        description: 'Snacks and drinks for the Friday team retro.',
        merchant: 'Carrefour',
        paymentMethod: PaymentMethod.cash,
        receiptRef: 'RCP-2026-0728',
      ),
      ExpenseModel(
        id: 'exp-5',
        title: 'Airport transfer',
        category: ExpenseCategory.mileage,
        date: on(7, 20),
        amount: 60.00,
        status: ExpenseStatus.pending,
        owner: ExpenseOwner.team,
        description:
            'Shared transfer from the airport to the office for the '
            'visiting developers.',
        merchant: 'Careem',
        paymentMethod: PaymentMethod.card,
        receiptRef: 'RCP-2026-0720',
      ),
    ];
  }
}
