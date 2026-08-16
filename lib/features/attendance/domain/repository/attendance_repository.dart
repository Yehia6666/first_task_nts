import '../entities/attendance_log.dart';

/// Repository contract. The presentation layer depends on this abstraction,
/// never on the concrete data source.
abstract class AttendanceRepository {
  Future<List<AttendanceLog>> getAttendanceLogs();
}
