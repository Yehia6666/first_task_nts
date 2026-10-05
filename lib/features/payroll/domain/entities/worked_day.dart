import 'package:equatable/equatable.dart';

/// One worked day line of a payslip.
class WorkedDay extends Equatable {
  const WorkedDay({
    required this.id,
    required this.code,
    required this.name,
    required this.numberOfDays,
    required this.numberOfHours,
    required this.amount,
  });

  final int id;
  final String code;
  final String name;
  final num numberOfDays;
  final num numberOfHours;
  final num amount;

  @override
  List<Object> get props => [
    id,
    code,
    name,
    numberOfDays,
    numberOfHours,
    amount,
  ];
}
