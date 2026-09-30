import 'package:equatable/equatable.dart';

enum TimeOffRequestStatus { approved, pending, rejected }

class TimeOffRequest extends Equatable {
  const TimeOffRequest({
    required this.id,
    required this.type,
    required this.duration,
    required this.startDate,
    required this.endDate,
    required this.note,
    required this.status,
  });

  final String id;
  final String type;
  final String duration;
  final DateTime startDate;
  final DateTime endDate;
  final String note;
  final TimeOffRequestStatus status;

  bool get isSingleDay =>
      startDate.year == endDate.year &&
      startDate.month == endDate.month &&
      startDate.day == endDate.day;

  @override
  List<Object?> get props => [id, type, duration, startDate, endDate, note, status];
}
