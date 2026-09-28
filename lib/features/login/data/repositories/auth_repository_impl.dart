import '../../../connection/domain/entities/database_url.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
    required DatabaseUrl databaseUrl,
  }) =>
      _remoteDataSource.signIn(
        email: email,
        password: password,
        databaseUrl: databaseUrl,
      );

  @override
  Future<String> requestPasswordReset({
    required String email,
    required DatabaseUrl databaseUrl,
  }) =>
      _remoteDataSource.forgotPassword(email: email, databaseUrl: databaseUrl);

  @override
  Future<void> saveAuthToken(String token) => _localDataSource.writeToken(token);

  @override
  Future<String?> loadAuthToken() => _localDataSource.readToken();

  @override
  Future<void> clearAuthToken() => _localDataSource.clearToken();
}
