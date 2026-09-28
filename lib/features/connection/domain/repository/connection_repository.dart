import '../entities/database_url.dart';
import '../entities/validated_database.dart';

abstract class ConnectionRepository {
  Future<ValidatedDatabase> validateDatabase(DatabaseUrl url);

  Future<void> saveDatabaseUrl(DatabaseUrl url);

  Future<DatabaseUrl?> loadSavedDatabaseUrl();
}
