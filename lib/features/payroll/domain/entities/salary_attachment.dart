import 'package:equatable/equatable.dart';

/// A salary attachment (running variable).
///
/// [dateEnd] is only sent by the detail endpoint, so it is absent on the list.
class SalaryAttachment extends Equatable {
  const SalaryAttachment({
    required this.id,
    required this.type,
    required this.typeCode,
    required this.noEndDate,
    required this.state,
    required this.remainingAmount,
    required this.paidAmount,
    required this.payslipIds,
    required this.payslipAmount,
    this.description,
    this.totalAmount,
    this.dateStart,
    this.estimatedEndDate,
    this.dateEnd,
    this.attachmentUrl,
  });

  final int id;
  final String type;
  final String typeCode;
  final bool noEndDate;
  final String state;
  final num remainingAmount;
  final num paidAmount;
  final num payslipAmount;
  final List<int> payslipIds;
  final String? description;
  final num? totalAmount;
  final String? dateStart;
  final String? estimatedEndDate;
  final String? dateEnd;
  final String? attachmentUrl;

  @override
  List<Object?> get props => [
    id,
    type,
    typeCode,
    noEndDate,
    state,
    remainingAmount,
    paidAmount,
    payslipAmount,
    payslipIds,
    description,
    totalAmount,
    dateStart,
    estimatedEndDate,
    dateEnd,
    attachmentUrl,
  ];
}
