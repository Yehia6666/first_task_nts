import '../../domain/entities/database_url.dart';
import '../../domain/entities/validated_database.dart';
import '../../domain/repository/connection_repository.dart';
import '../datasources/database_validation_remote_data_source.dart';
import '../datasources/server_config_local_data_source.dart';

class ConnectionRepositoryImpl implements ConnectionRepository {
  const ConnectionRepositoryImpl(
    this._remoteDataSource,
    this._configDataSource,
  );

  final DatabaseValidationRemoteDataSource _remoteDataSource;
  final ServerConfigLocalDataSource _configDataSource;

  @override
  Future<ValidatedDatabase> validateDatabase(DatabaseUrl url) async {
    final model = await _remoteDataSource.validateDatabase(url);
    return model.toEntity();
  }

  @override
  Future<void> saveDatabaseUrl(DatabaseUrl url) => _configDataSource.writeDatabaseUrl(url);

  @override
  Future<DatabaseUrl?> loadSavedDatabaseUrl() => _configDataSource.readDatabaseUrl();
}
