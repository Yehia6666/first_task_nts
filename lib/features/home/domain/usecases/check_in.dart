import '../entities/attendance_session.dart';
import '../repository/home_repository.dart';

/// Records the worker's check-in and returns the updated session.
class CheckIn {
  const CheckIn(this._repository);

  final HomeRepository _repository;

  Future<AttendanceSession> call(DateTime now) => _repository.checkIn(now);
}
