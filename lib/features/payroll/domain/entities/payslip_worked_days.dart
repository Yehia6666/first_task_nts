import 'package:equatable/equatable.dart';

import 'payslip_input.dart';
import 'worked_day.dart';

/// Worked days and input lines of a single payslip.
class PayslipWorkedDays extends Equatable {
  const PayslipWorkedDays({
    required this.payslipId,
    required this.workedDays,
    required this.inputs,
  });

  final int payslipId;
  final List<WorkedDay> workedDays;
  final List<PayslipInput> inputs;

  @override
  List<Object> get props => [payslipId, workedDays, inputs];
}
