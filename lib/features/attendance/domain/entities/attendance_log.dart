import 'package:equatable/equatable.dart';

enum AttendanceType { checkIn, checkOut }

enum AttendanceStatus { completed, pending }

/// Pure domain entity. No Flutter imports.
class AttendanceLog extends Equatable {
  const AttendanceLog({
    required this.id,
    required this.type,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
    this.workedHours,
  });

  final String id;
  final AttendanceType type;
  final DateTime date;
  final DateTime time;
  final String location;
  final AttendanceStatus status;
  final double? workedHours;

  String get typeLabel => type == AttendanceType.checkIn ? 'Check In' : 'Check Out';

  String get statusLabel =>
      status == AttendanceStatus.completed ? 'Completed' : 'Pending';

  @override
  List<Object?> get props => [id, type, date, time, location, status, workedHours];
}
