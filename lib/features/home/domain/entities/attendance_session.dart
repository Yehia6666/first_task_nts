import 'package:equatable/equatable.dart';

enum AttendanceSessionStatus { notCheckedIn, checkedIn, checkedOut }

/// Pure domain entity describing the current attendance session on the Home
/// screen. No Flutter imports.
class AttendanceSession extends Equatable {
  const AttendanceSession({
    required this.id,
    required this.date,
    required this.earliestEvent,
    required this.targetEnd,
    required this.location,
    required this.status,
    this.checkInAt,
  });

  final String id;
  final DateTime date;
  final DateTime earliestEvent;
  final DateTime targetEnd;
  final String location;
  final AttendanceSessionStatus status;
  final DateTime? checkInAt;

  /// Fraction (0..1) of the working window that has elapsed by [now],
  /// clamped so the progress bar never overflows.
  double progressAt(DateTime now) {
    final total = targetEnd.difference(earliestEvent).inSeconds;
    if (total <= 0) return 0;
    final elapsed = now.difference(earliestEvent).inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  @override
  List<Object?> get props => [
        id,
        date,
        earliestEvent,
        targetEnd,
        location,
        status,
        checkInAt,
      ];
}
