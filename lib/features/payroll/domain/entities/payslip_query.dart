import 'package:equatable/equatable.dart';

/// Query parameters accepted by the payslips endpoint.
///
/// [dateFromMin] and [dateFromMax] are optional `YYYY-MM-DD` bounds;
/// [limit] and [offset] keep the documented defaults of 50 and 0.
class PayslipQuery extends Equatable {
  const PayslipQuery({
    this.dateFromMin,
    this.dateFromMax,
    this.limit = defaultLimit,
    this.offset = defaultOffset,
  });

  static const int defaultLimit = 50;
  static const int defaultOffset = 0;

  final String? dateFromMin;
  final String? dateFromMax;
  final int limit;
  final int offset;

  PayslipQuery copyWith({
    String? dateFromMin,
    String? dateFromMax,
    int? limit,
    int? offset,
  }) {
    return PayslipQuery(
      dateFromMin: dateFromMin ?? this.dateFromMin,
      dateFromMax: dateFromMax ?? this.dateFromMax,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  @override
  List<Object?> get props => [dateFromMin, dateFromMax, limit, offset];
}
