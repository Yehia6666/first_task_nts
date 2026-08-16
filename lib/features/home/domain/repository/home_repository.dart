import '../entities/attendance_session.dart';

/// Repository contract for the Home feature. The presentation layer depends
/// on this abstraction, never on the concrete data source.
abstract class HomeRepository {
  Future<AttendanceSession> getTodaySession();
  Future<AttendanceSession> checkIn(DateTime now);
}
