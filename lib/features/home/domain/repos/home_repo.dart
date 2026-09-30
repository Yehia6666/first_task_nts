import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/attendance_session.dart';

/// Repository contract for the Home feature. The presentation layer depends
/// on this abstraction, never on the concrete data source.
abstract class HomeRepo {
  Future<Either<Failure, AttendanceSession>> getTodaySession();
  Future<Either<Failure, AttendanceSession>> checkIn(DateTime now);
}
