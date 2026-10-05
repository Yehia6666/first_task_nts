import 'package:equatable/equatable.dart';

/// One payslip as returned by the payslip detail endpoint.
///
/// [pdfUrl] is only present once the payslip is done or paid, matching
/// [pdfAvailable].
class PayslipDetail extends Equatable {
  const PayslipDetail({
    required this.id,
    required this.name,
    required this.state,
    required this.employeeId,
    required this.employeeName,
    required this.pdfAvailable,
    this.dateFrom,
    this.dateTo,
    this.contractId,
    this.contractName,
    this.basicWage,
    this.grossWage,
    this.netWage,
    this.totalDeductions,
    this.currencyId,
    this.currencyCode,
    this.pdfUrl,
  });

  final int id;
  final String name;
  final String state;
  final int employeeId;
  final String employeeName;
  final bool pdfAvailable;
  final String? dateFrom;
  final String? dateTo;
  final int? contractId;
  final String? contractName;
  final num? basicWage;
  final num? grossWage;
  final num? netWage;
  final num? totalDeductions;
  final int? currencyId;
  final String? currencyCode;
  final String? pdfUrl;

  @override
  List<Object?> get props => [
    id,
    name,
    state,
    employeeId,
    employeeName,
    pdfAvailable,
    dateFrom,
    dateTo,
    contractId,
    contractName,
    basicWage,
    grossWage,
    netWage,
    totalDeductions,
    currencyId,
    currencyCode,
    pdfUrl,
  ];
}
