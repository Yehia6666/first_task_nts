import '../../domain/entities/payslip_detail.dart';

class PayslipDetailModel extends PayslipDetail {
  const PayslipDetailModel({
    required super.id,
    required super.name,
    required super.state,
    required super.employeeId,
    required super.employeeName,
    required super.pdfAvailable,
    super.dateFrom,
    super.dateTo,
    super.contractId,
    super.contractName,
    super.basicWage,
    super.grossWage,
    super.netWage,
    super.totalDeductions,
    super.currencyId,
    super.currencyCode,
    super.pdfUrl,
  });

  factory PayslipDetailModel.fromJson(Map<String, dynamic> json) {
    return PayslipDetailModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      state: json['state'] as String? ?? '',
      employeeId: json['employee_id'] as int? ?? 0,
      employeeName: json['employee_name'] as String? ?? '',
      pdfAvailable: json['pdf_available'] as bool? ?? false,
      dateFrom: json['date_from'] as String?,
      dateTo: json['date_to'] as String?,
      contractId: json['contract_id'] as int?,
      contractName: json['contract_name'] as String?,
      basicWage: json['basic_wage'] as num?,
      grossWage: json['gross_wage'] as num?,
      netWage: json['net_wage'] as num?,
      totalDeductions: json['total_deductions'] as num?,
      currencyId: json['currency_id'] as int?,
      currencyCode: json['currency_code'] as String?,
      pdfUrl: json['pdf_url'] as String?,
    );
  }
}
