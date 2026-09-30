import '../entities/attendance_session.dart';
import '../repos/home_repo.dart';

/// Loads the current attendance session through the repository abstraction.
class GetTodaySessionUseCase {
  const GetTodaySessionUseCase(this._repository);

  final HomeRepo _repository;

  Future<AttendanceSession> call() => _repository.getTodaySession();
}
