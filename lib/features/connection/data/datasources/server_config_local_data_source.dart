import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/database_url.dart';

class ServerConfigLocalDataSource {
  static const String _databaseUrlKey = 'connection.database_url';

  Future<DatabaseUrl?> readDatabaseUrl() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? raw = preferences.getString(_databaseUrlKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      return DatabaseUrl.parse(raw);
    } on InvalidDatabaseUrlException {
      return null;
    }
  }

  Future<void> writeDatabaseUrl(DatabaseUrl url) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(_databaseUrlKey, url.value.toString());
  }
}
