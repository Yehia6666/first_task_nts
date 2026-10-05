import '../../domain/entities/payslip_line.dart';

class PayslipLineModel extends PayslipLine {
  const PayslipLineModel({
    required super.id,
    required super.code,
    required super.name,
    required super.amount,
    required super.total,
    required super.availableOnPayslip,
    super.categoryCode,
    super.categoryName,
  });

  factory PayslipLineModel.fromJson(Map<String, dynamic> json) {
    return PayslipLineModel(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      amount: json['amount'] as num? ?? 0,
      total: json['total'] as num? ?? 0,
      availableOnPayslip: json['available_on_payslip'] as bool? ?? false,
      categoryCode: json['category_code'] as String?,
      categoryName: json['category_name'] as String?,
    );
  }
}
