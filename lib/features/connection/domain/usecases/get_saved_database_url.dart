import '../entities/database_url.dart';
import '../repository/connection_repository.dart';

class GetSavedDatabaseUrl {
  const GetSavedDatabaseUrl(this._repository);

  final ConnectionRepository _repository;

  Future<DatabaseUrl?> call() => _repository.loadSavedDatabaseUrl();
}
