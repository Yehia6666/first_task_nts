import 'package:equatable/equatable.dart';

/// Aggregated amounts shown by the summary cards.
class ExpenseSummary extends Equatable {
  const ExpenseSummary({
    required this.toReport,
    required this.pending,
    required this.paid,
  });

  final double toReport;
  final double pending;
  final double paid;

  static const ExpenseSummary empty = ExpenseSummary(
    toReport: 0,
    pending: 0,
    paid: 0,
  );

  @override
  List<Object?> get props => [toReport, pending, paid];
}
