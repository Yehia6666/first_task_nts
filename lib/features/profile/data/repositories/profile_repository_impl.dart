import '../../../connection/domain/entities/database_url.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repository/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<UserProfile> getProfile({
    required String token,
    required DatabaseUrl databaseUrl,
  }) =>
      _remoteDataSource.getProfile(token: token, databaseUrl: databaseUrl);
}
