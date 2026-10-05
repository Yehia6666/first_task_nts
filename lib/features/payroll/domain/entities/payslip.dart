import 'package:equatable/equatable.dart';

/// A single payslip record.
///
/// Only [dateFrom] is mapped to a typed field, because it is the sole payslip
/// field documented for this endpoint (results are ordered by it and it backs
/// the `date_from_min` / `date_from_max` filters). [raw] keeps the untouched
/// response object so no server value is discarded and the remaining payslip
/// fields can be mapped once their schema is confirmed.
class Payslip extends Equatable {
  const Payslip({required this.dateFrom, required this.raw});

  /// Period start date, `YYYY-MM-DD` as returned by the API.
  final String dateFrom;

  /// The payslip object exactly as received.
  final Map<String, dynamic> raw;

  @override
  List<Object> get props => [dateFrom, raw];
}
