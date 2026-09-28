import '../entities/database_url.dart';

class ValidateDatabaseUrl {
  const ValidateDatabaseUrl();

  DatabaseUrl call(String raw) => DatabaseUrl.parse(raw);
}
