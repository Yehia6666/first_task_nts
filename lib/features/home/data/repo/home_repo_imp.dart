import '../../domain/entities/attendance_session.dart';
import '../../domain/repos/home_repo.dart';
import '../data_source/home_local_data_source.dart';

/// Implements the domain contract. UI never depends on this class directly;
/// swap the data source here when a real API is added.
class HomeRepoImp implements HomeRepo {
  const HomeRepoImp(this._dataSource);

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
