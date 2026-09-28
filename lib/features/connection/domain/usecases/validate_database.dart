import '../entities/database_url.dart';
import '../entities/validated_database.dart';
import '../repository/connection_repository.dart';

class ValidateDatabase {
  const ValidateDatabase(this._repository);

  final ConnectionRepository _repository;

  Future<ValidatedDatabase> call(DatabaseUrl url) => _repository.validateDatabase(url);
}
