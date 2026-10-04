import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/attendance_session.dart';
import '../../domain/repos/home_repo.dart';
import '../data_source/home_local_data_source.dart';

/// Implements the domain contract. UI never depends on this class directly;
/// swap the data source here when a real API is added.
class HomeRepoImp implements HomeRepo {
  const HomeRepoImp(this._dataSource);

  final HomeLocalDataSource _dataSource;

  @override
  Future<Either<Failure, AttendanceSession>> getTodaySession() async {
    try {
      final model = await _dataSource.getTodaySession();
      return Right(model.toEntity());
    } catch (_) {
      return Left(
        ServerFaliure('We could not load your session. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, AttendanceSession>> checkIn(DateTime now) async {
    try {
      final model = await _dataSource.checkIn(now);
      return Right(model.toEntity());
    } catch (_) {
      return Left(
        ServerFaliure('We could not check you in. Please try again.'),
      );
    }
  }
}
