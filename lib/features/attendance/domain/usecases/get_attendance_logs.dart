import '../entities/attendance_log.dart';
import '../repository/attendance_repository.dart';

/// Loads all attendance logs through the repository abstraction.
class GetAttendanceLogs {
  const GetAttendanceLogs(this._repository);

  final AttendanceRepository _repository;

  Future<List<AttendanceLog>> call() => _repository.getAttendanceLogs();
}
