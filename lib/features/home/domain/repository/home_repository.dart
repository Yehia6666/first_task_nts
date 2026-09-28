import '../entities/attendance_session.dart';

abstract class HomeRepository {
  Future<AttendanceSession> getTodaySession();
  Future<AttendanceSession> checkIn(DateTime now);
}
