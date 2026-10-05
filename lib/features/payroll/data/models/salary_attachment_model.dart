import '../../domain/entities/salary_attachment.dart';

class SalaryAttachmentModel extends SalaryAttachment {
  const SalaryAttachmentModel({
    required super.id,
    required super.type,
    required super.typeCode,
    required super.noEndDate,
    required super.state,
    required super.remainingAmount,
    required super.paidAmount,
    required super.payslipAmount,
    required super.payslipIds,
    super.description,
    super.totalAmount,
    super.dateStart,
    super.estimatedEndDate,
    super.dateEnd,
    super.attachmentUrl,
  });

  factory SalaryAttachmentModel.fromJson(Map<String, dynamic> json) {
    final payslipIds = json['payslip_ids'] as List<dynamic>? ?? const [];

    return SalaryAttachmentModel(
      id: json['id'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      typeCode: json['type_code'] as String? ?? '',
      noEndDate: json['no_end_date'] as bool? ?? false,
      state: json['state'] as String? ?? '',
      remainingAmount: json['remaining_amount'] as num? ?? 0,
      paidAmount: json['paid_amount'] as num? ?? 0,
      payslipAmount: json['payslip_amount'] as num? ?? 0,
      payslipIds: payslipIds.whereType<int>().toList(),
      description: json['description'] as String?,
      totalAmount: json['total_amount'] as num?,
      dateStart: json['date_start'] as String?,
      estimatedEndDate: json['estimated_end_date'] as String?,
      dateEnd: json['date_end'] as String?,
      attachmentUrl: json['attachment_url'] as String?,
    );
  }
}
