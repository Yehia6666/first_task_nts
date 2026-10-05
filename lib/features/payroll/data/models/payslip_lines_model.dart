import '../../domain/entities/payslip_lines.dart';
import 'payslip_line_model.dart';

class PayslipLinesModel extends PayslipLines {
  const PayslipLinesModel({required super.payslipId, required super.lines});

  factory PayslipLinesModel.fromJson(Map<String, dynamic> json) {
    final lines = json['lines'] as List<dynamic>? ?? const [];

    return PayslipLinesModel(
      payslipId: json['payslip_id'] as int? ?? 0,
      lines: lines
          .whereType<Map<String, dynamic>>()
          .map(PayslipLineModel.fromJson)
          .toList(),
    );
  }
}
