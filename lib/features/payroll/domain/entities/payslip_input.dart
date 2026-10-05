import 'package:equatable/equatable.dart';

/// One input line of a payslip.
class PayslipInput extends Equatable {
  const PayslipInput({
    required this.id,
    required this.code,
    required this.name,
    required this.amount,
  });

  final int id;
  final String code;
  final String name;
  final num amount;

  @override
  List<Object> get props => [id, code, name, amount];
}
