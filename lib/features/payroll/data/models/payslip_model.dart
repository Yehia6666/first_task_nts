import '../../domain/entities/payslip.dart';

class PayslipModel extends Payslip {
  const PayslipModel({required super.dateFrom, required super.raw});

  factory PayslipModel.fromJson(Map<String, dynamic> json) {
    return PayslipModel(
      dateFrom: json['date_from']?.toString() ?? '',
      raw: json,
    );
  }
}
