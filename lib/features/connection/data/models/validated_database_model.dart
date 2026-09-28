import '../../domain/entities/database_url.dart';
import '../../domain/entities/validated_database.dart';

class ValidatedDatabaseModel extends ValidatedDatabase {
  const ValidatedDatabaseModel({
    required super.database,
    required super.baseUrl,
    super.statusMessage,
  });

  factory ValidatedDatabaseModel.fromJson(
    Map<String, dynamic> json, {
    required DatabaseUrl requestedUrl,
    String? statusMessage,
  }) {
    return ValidatedDatabaseModel(
      database: json['database'] as String,
      baseUrl: DatabaseUrl.parse(
        (json['base_url'] as String?) ?? requestedUrl.toString(),
      ),
      statusMessage: statusMessage,
    );
  }

  ValidatedDatabase toEntity() => ValidatedDatabase(
        database: database,
        baseUrl: baseUrl,
        statusMessage: statusMessage,
      );
}
