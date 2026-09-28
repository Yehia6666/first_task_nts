import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.title,
    required super.category,
    required super.date,
    required super.amount,
    required super.status,
    required super.owner,
    super.description,
    super.merchant,
    super.paymentMethod,
    super.receiptRef,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: ExpenseCategory.values.byName(json['category'] as String),
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
      status: ExpenseStatus.values.byName(json['status'] as String),
      owner: ExpenseOwner.values.byName(json['owner'] as String),
      description: json['description'] as String? ?? '',
      merchant: json['merchant'] as String? ?? '',
      paymentMethod: json['paymentMethod'] == null
          ? null
          : PaymentMethod.values.byName(json['paymentMethod'] as String),
      receiptRef: json['receiptRef'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category.name,
    'date': date.toIso8601String(),
    'amount': amount,
    'status': status.name,
    'owner': owner.name,
    'description': description,
    'merchant': merchant,
    'paymentMethod': paymentMethod?.name,
    'receiptRef': receiptRef,
  };

  Expense toEntity() => Expense(
    id: id,
    title: title,
    category: category,
    date: date,
    amount: amount,
    status: status,
    owner: owner,
    description: description,
    merchant: merchant,
    paymentMethod: paymentMethod,
    receiptRef: receiptRef,
  );
}
