import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  static const String _tokenKey = 'auth.session_token';

  Future<String?> readToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString(_tokenKey);
    return (token == null || token.isEmpty) ? null : token;
  }

  Future<void> writeToken(String token) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(_tokenKey);
  }
}
