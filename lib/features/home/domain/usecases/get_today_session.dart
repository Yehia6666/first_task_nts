import '../entities/attendance_session.dart';
import '../repository/home_repository.dart';

class GetTodaySession {
  const GetTodaySession(this._repository);

  final HomeRepository _repository;

  Future<AttendanceSession> call() => _repository.getTodaySession();
}
