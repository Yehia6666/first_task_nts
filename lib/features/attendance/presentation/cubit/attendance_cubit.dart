import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_formatters.dart';
import '../../domain/entities/attendance_filters.dart';
import '../../domain/entities/attendance_log.dart';
import '../../domain/usecases/filter_attendance_logs.dart';
import '../../domain/usecases/get_attendance_logs.dart';
import '../states/attendance_state.dart';

/// Holds attendance state, delegates business logic to use cases, and emits
/// states the UI renders. Contains no layout/widget code.
class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit({
    required this.getAttendanceLogs,
    required this.filterAttendanceLogs,
  }) : super(const AttendanceInitial()) {
    load();
  }

  final GetAttendanceLogs getAttendanceLogs;
  final FilterAttendanceLogs filterAttendanceLogs;

  List<AttendanceLog> _allLogs = const [];
  AttendanceTypeFilter _typeFilter = AttendanceTypeFilter.all;
  AttendanceStatusFilter _statusFilter = AttendanceStatusFilter.all;
  String _searchQuery = '';

  Future<void> load() async {
    emit(const AttendanceLoading());
    try {
      _allLogs = await getAttendanceLogs();
      _emitFiltered();
    } catch (_) {
      emit(const AttendanceError(
        'We could not load your attendance logs. Please try again.',
      ));
    }
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _emitFiltered();
  }

  void onTypeFilterChanged(AttendanceTypeFilter filter) {
    _typeFilter = filter;
    _emitFiltered();
  }

  void onStatusFilterChanged(AttendanceStatusFilter filter) {
    _statusFilter = filter;
    _emitFiltered();
  }

  void _emitFiltered() {
    final filtered = filterAttendanceLogs(
      logs: _allLogs,
      type: _typeFilter,
      status: _statusFilter,
      query: _searchQuery,
    );

    emit(AttendanceLoaded(
      sections: _groupByDay(filtered),
      allLogs: List.of(_allLogs),
      typeFilter: _typeFilter,
      statusFilter: _statusFilter,
      searchQuery: _searchQuery,
    ));
  }

  List<AttendanceDaySection> _groupByDay(List<AttendanceLog> logs) {
    final grouped = <DateTime, List<AttendanceLog>>{};
    for (final log in logs) {
      final day = DateTime(log.date.year, log.date.month, log.date.day);
      grouped.putIfAbsent(day, () => []).add(log);
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final days = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return days.map((day) {
      final title = day == today
          ? 'Today'
          : day == yesterday
              ? 'Yesterday'
              : AppFormatters.day(day);
      final logsForDay = grouped[day]!
        ..sort((a, b) => b.time.compareTo(a.time));
      return AttendanceDaySection(title: title, date: day, logs: logsForDay);
    }).toList();
  }
}
