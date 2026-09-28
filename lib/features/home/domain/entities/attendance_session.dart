import 'package:equatable/equatable.dart';

enum AttendanceSessionStatus { notCheckedIn, checkedIn, checkedOut }

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
