import 'package:equatable/equatable.dart';

enum ExpenseStatus { toReport, pending, paid }

enum ExpenseCategory { meals, mileage, travel, other }

enum ExpenseOwner { me, team }

enum PaymentMethod { cash, card, online }

class Expense extends Equatable {
  const Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.status,
    required this.owner,
    this.description = '',
    this.merchant = '',
    this.paymentMethod,
    this.receiptRef = '',
  });

  final String id;
  final String title;
  final ExpenseCategory category;
  final DateTime date;
  final double amount;
  final ExpenseStatus status;
  final ExpenseOwner owner;
  final String description;
  final String merchant;
  final PaymentMethod? paymentMethod;
  final String receiptRef;

  String get categoryLabel => switch (category) {
    ExpenseCategory.meals => 'Meals',
    ExpenseCategory.mileage => 'Mileage',
    ExpenseCategory.travel => 'Travel',
    ExpenseCategory.other => 'Other',
  };

  String get statusLabel => switch (status) {
    ExpenseStatus.toReport => 'To Report',
    ExpenseStatus.pending => 'Pending',
    ExpenseStatus.paid => 'Paid',
  };

  String get paymentMethodLabel => switch (paymentMethod) {
    PaymentMethod.cash => 'Cash',
    PaymentMethod.card => 'Card',
    PaymentMethod.online => 'Online',
    null => '—',
  };

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    date,
    amount,
    status,
    owner,
    description,
    merchant,
    paymentMethod,
    receiptRef,
  ];
}
