import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/attendance_session.dart';
import '../repos/home_repo.dart';

/// Loads the current attendance session through the repository abstraction.
class GetTodaySessionUseCase extends UseCase<AttendanceSession, NoParams> {
  const GetTodaySessionUseCase(this._repository);

  final HomeRepo _repository;

  @override
  Future<Either<Failure, AttendanceSession>> call([
    NoParams param = const NoParams(),
  ]) {
    return _repository.getTodaySession();
  }
}
