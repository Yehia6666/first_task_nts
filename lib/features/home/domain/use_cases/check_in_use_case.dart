import '../entities/attendance_session.dart';
import '../repos/home_repo.dart';

/// Records the worker's check-in and returns the updated session.
class CheckInUseCase {
  const CheckInUseCase(this._repository);

  final HomeRepo _repository;

  Future<AttendanceSession> call(DateTime now) => _repository.checkIn(now);
}
