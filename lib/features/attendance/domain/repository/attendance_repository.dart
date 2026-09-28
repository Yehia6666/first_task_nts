import '../entities/attendance_log.dart';

abstract class AttendanceRepository {
  Future<List<AttendanceLog>> getAttendanceLogs();
}
