import '../../domain/entities/attendance_log.dart';
import '../models/attendance_log_model.dart';

class AttendanceLocalDataSource {
  static const String _location = 'مبنى رقم 9، شارع الأمير تركي بن عبدالعزيز، الرياض';

  Future<List<AttendanceLogModel>> getAttendanceLogs() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _buildMockLogs();
  }

  List<AttendanceLogModel> _buildMockLogs() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    DateTime on(DateTime day, int hour, int minute) =>
        DateTime(day.year, day.month, day.day, hour, minute);

    return [
      AttendanceLogModel(
        id: 'att-1',
        type: AttendanceType.checkIn,
        date: today,
        time: on(today, 10, 49),
        location: _location,
        status: AttendanceStatus.completed,
      ),
      AttendanceLogModel(
        id: 'att-2',
        type: AttendanceType.checkOut,
        date: yesterday,
        time: on(yesterday, 17, 45),
        location: _location,
        status: AttendanceStatus.completed,
        workedHours: 3.73,
      ),
      AttendanceLogModel(
        id: 'att-3',
        type: AttendanceType.checkIn,
        date: yesterday,
        time: on(yesterday, 14, 1),
        location: _location,
        status: AttendanceStatus.completed,
      ),
      AttendanceLogModel(
        id: 'att-4',
        type: AttendanceType.checkOut,
        date: yesterday,
        time: on(yesterday, 12, 30),
        location: _location,
        status: AttendanceStatus.completed,
        workedHours: 3.5,
      ),
      AttendanceLogModel(
        id: 'att-5',
        type: AttendanceType.checkIn,
        date: yesterday,
        time: on(yesterday, 9, 15),
        location: _location,
        status: AttendanceStatus.completed,
      ),
      AttendanceLogModel(
        id: 'att-6',
        type: AttendanceType.checkIn,
        date: yesterday,
        time: on(yesterday, 8, 50),
        location: _location,
        status: AttendanceStatus.pending,
      ),
    ];
  }
}
