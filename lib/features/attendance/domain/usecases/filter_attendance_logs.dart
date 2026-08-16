import '../entities/attendance_filters.dart';
import '../entities/attendance_log.dart';

/// Application logic for filtering and searching attendance logs.
/// Kept outside widgets and the Cubit so it can be reused and unit-tested.
class FilterAttendanceLogs {
  const FilterAttendanceLogs();

  List<AttendanceLog> call({
    required List<AttendanceLog> logs,
    AttendanceTypeFilter type = AttendanceTypeFilter.all,
    AttendanceStatusFilter status = AttendanceStatusFilter.all,
    String query = '',
  }) {
    final normalizedQuery = query.trim().toLowerCase();

    return logs.where((log) {
      final matchesType = switch (type) {
        AttendanceTypeFilter.all => true,
        AttendanceTypeFilter.checkIn => log.type == AttendanceType.checkIn,
        AttendanceTypeFilter.checkOut => log.type == AttendanceType.checkOut,
      };

      final matchesStatus = switch (status) {
        AttendanceStatusFilter.all => true,
        AttendanceStatusFilter.completed => log.status == AttendanceStatus.completed,
        AttendanceStatusFilter.pending => log.status == AttendanceStatus.pending,
      };

      final matchesQuery = normalizedQuery.isEmpty || _matches(log, normalizedQuery);

      return matchesType && matchesStatus && matchesQuery;
    }).toList();
  }

  /// Matches every piece of text visible on an attendance card: the type label,
  /// the address/details line, the status badge, and the worked-hours note.
  bool _matches(AttendanceLog log, String normalizedQuery) {
    final hours = log.workedHours == null
        ? ''
        : 'worked ${log.workedHours!.toStringAsFixed(2)}h';
    final searchable = [
      log.typeLabel,
      log.location,
      log.statusLabel,
      hours,
    ].join(' ').toLowerCase();
    return searchable.contains(normalizedQuery);
  }
}
