import '../../domain/entities/payslip_input.dart';

class PayslipInputModel extends PayslipInput {
  const PayslipInputModel({
    required super.id,
    required super.code,
    required super.name,
    required super.amount,
  });

  factory PayslipInputModel.fromJson(Map<String, dynamic> json) {
    return PayslipInputModel(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      amount: json['amount'] as num? ?? 0,
    );
  }
}
