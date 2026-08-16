import 'package:equatable/equatable.dart';

import '../../domain/entities/attendance_filters.dart';
import '../../domain/entities/attendance_log.dart';

/// A grouped day section shown in the UI (e.g. "Today", "Yesterday").
class AttendanceDaySection {
  const AttendanceDaySection({
    required this.title,
    required this.date,
    required this.logs,
  });

  final String title;
  final DateTime date;
  final List<AttendanceLog> logs;
}

sealed class AttendanceState extends Equatable {
  const AttendanceState();
}

class AttendanceInitial extends AttendanceState {
  const AttendanceInitial();

  @override
  List<Object?> get props => [];
}

class AttendanceLoading extends AttendanceState {
  const AttendanceLoading();

  @override
  List<Object?> get props => [];
}

class AttendanceLoaded extends AttendanceState {
  const AttendanceLoaded({
    required this.sections,
    required this.allLogs,
    required this.typeFilter,
    required this.statusFilter,
    required this.searchQuery,
  });

  final List<AttendanceDaySection> sections;
  final List<AttendanceLog> allLogs;
  final AttendanceTypeFilter typeFilter;
  final AttendanceStatusFilter statusFilter;
  final String searchQuery;

  @override
  List<Object?> get props => [
        sections,
        allLogs,
        typeFilter,
        statusFilter,
        searchQuery,
      ];
}

class AttendanceError extends AttendanceState {
  const AttendanceError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
