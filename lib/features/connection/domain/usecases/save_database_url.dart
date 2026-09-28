import '../entities/database_url.dart';
import '../repository/connection_repository.dart';

class SaveDatabaseUrl {
  const SaveDatabaseUrl(this._repository);

  final ConnectionRepository _repository;

  Future<void> call(DatabaseUrl url) => _repository.saveDatabaseUrl(url);
}
