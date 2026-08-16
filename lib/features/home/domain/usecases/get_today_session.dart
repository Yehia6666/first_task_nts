import '../entities/attendance_session.dart';
import '../repository/home_repository.dart';

/// Loads the current attendance session through the repository abstraction.
class GetTodaySession {
  const GetTodaySession(this._repository);

  final HomeRepository _repository;

  Future<AttendanceSession> call() => _repository.getTodaySession();
}
