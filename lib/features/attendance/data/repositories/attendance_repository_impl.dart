import '../../domain/entities/attendance_log.dart';
import '../../domain/repository/attendance_repository.dart';
import '../datasources/attendance_local_data_source.dart';
import '../models/attendance_log_model.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  const AttendanceRepositoryImpl(this._dataSource);

  final AttendanceLocalDataSource _dataSource;

  @override
  Future<List<AttendanceLog>> getAttendanceLogs() async {
    final models = await _dataSource.getAttendanceLogs();
    return models.map((AttendanceLogModel m) => m.toEntity()).toList();
  }
}
