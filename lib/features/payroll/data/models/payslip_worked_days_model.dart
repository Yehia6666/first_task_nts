import '../../domain/entities/payslip_worked_days.dart';
import 'payslip_input_model.dart';
import 'worked_day_model.dart';

class PayslipWorkedDaysModel extends PayslipWorkedDays {
  const PayslipWorkedDaysModel({
    required super.payslipId,
    required super.workedDays,
    required super.inputs,
  });

  factory PayslipWorkedDaysModel.fromJson(Map<String, dynamic> json) {
    final workedDays = json['worked_days'] as List<dynamic>? ?? const [];
    final inputs = json['inputs'] as List<dynamic>? ?? const [];

    return PayslipWorkedDaysModel(
      payslipId: json['payslip_id'] as int? ?? 0,
      workedDays: workedDays
          .whereType<Map<String, dynamic>>()
          .map(WorkedDayModel.fromJson)
          .toList(),
      inputs: inputs
          .whereType<Map<String, dynamic>>()
          .map(PayslipInputModel.fromJson)
          .toList(),
    );
  }
}
