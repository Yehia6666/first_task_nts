import '../../domain/entities/attendance_session.dart';
import '../models/attendance_session_model.dart';

class HomeLocalDataSource {
  static const String _location = 'مبنى رقم 9، شارع الأمير تركي بن عبدالعزيز، الرياض';

  AttendanceSessionModel? _session;

  Future<AttendanceSessionModel> getTodaySession() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _session ??= AttendanceSessionModel(
          id: 'session-1',
          date: today,
          earliestEvent: DateTime(today.year, today.month, today.day, 9, 0),
          targetEnd: DateTime(today.year, today.month, today.day, 17, 0),
          location: _location,
          status: AttendanceSessionStatus.notCheckedIn,
        );
  }

  Future<AttendanceSessionModel> checkIn(DateTime now) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final current = await getTodaySession();
    return _session = current.copyWith(
      status: AttendanceSessionStatus.checkedIn,
      checkInAt: now,
    );
  }
}
