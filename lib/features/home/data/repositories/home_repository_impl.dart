import '../../domain/entities/attendance_session.dart';
import '../../domain/repository/home_repository.dart';
import '../datasources/home_local_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._dataSource);

  final HomeLocalDataSource _dataSource;

  @override
  Future<AttendanceSession> getTodaySession() async {
    final model = await _dataSource.getTodaySession();
    return model.toEntity();
  }

  @override
  Future<AttendanceSession> checkIn(DateTime now) async {
    final model = await _dataSource.checkIn(now);
    return model.toEntity();
  }
}
