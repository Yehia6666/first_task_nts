import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/attendance_session.dart';
import '../repos/home_repo.dart';

/// Records the worker's check-in and returns the updated session.
class CheckInUseCase extends UseCase<AttendanceSession, DateTime> {
  const CheckInUseCase(this._repository);

  final HomeRepo _repository;

  @override
  Future<Either<Failure, AttendanceSession>> call(DateTime now) {
    return _repository.checkIn(now);
  }
}
