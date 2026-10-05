import 'package:equatable/equatable.dart';

/// One salary computation line (earning or deduction) of a payslip.
class PayslipLine extends Equatable {
  const PayslipLine({
    required this.id,
    required this.code,
    required this.name,
    required this.amount,
    required this.total,
    required this.availableOnPayslip,
    this.categoryCode,
    this.categoryName,
  });

  final int id;
  final String code;
  final String name;
  final num amount;
  final num total;

  /// Whether the salary rule is configured to appear on the payslip.
  final bool availableOnPayslip;
  final String? categoryCode;
  final String? categoryName;

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    amount,
    total,
    availableOnPayslip,
    categoryCode,
    categoryName,
  ];
}
