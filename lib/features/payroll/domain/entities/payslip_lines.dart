import 'package:equatable/equatable.dart';

import 'payslip_line.dart';

/// Salary computation lines of a single payslip.
class PayslipLines extends Equatable {
  const PayslipLines({required this.payslipId, required this.lines});

  final int payslipId;
  final List<PayslipLine> lines;

  @override
  List<Object> get props => [payslipId, lines];
}
