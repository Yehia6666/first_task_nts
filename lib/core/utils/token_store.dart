import 'package:shared_preferences/shared_preferences.dart';

/// Single owner of the persisted authentication token.
///
/// The token is written once, after a successful sign-in, and read by every
/// protected request. It is also kept in memory so callers on the UI side do
/// not have to await storage on every rebuild.
class TokenStore {
  TokenStore(this._preferences);

  final SharedPreferences _preferences;

  /// Storage key for the bearer token.
  static const String tokenKey = 'auth_token';

  String? _cached;

  /// The last known token, without touching storage. Null until [read] runs.
  String? get cached => _cached;

  /// Persists [token] and updates the in-memory copy.
  Future<void> save(String token) async {
    _cached = token;
    await _preferences.setString(tokenKey, token);
  }

  /// Returns the saved token, or null when the user has not signed in.
  Future<String?> read() async {
    final cached = _cached;
    if (cached != null) return cached;
    return _cached = _preferences.getString(tokenKey);
  }

  /// Removes the stored token.
  Future<void> clear() async {
    _cached = null;
    await _preferences.remove(tokenKey);
  }

  /// Headers for a protected request. The only place that builds them, so the
  /// scheme stays consistent across endpoints.
  Map<String, dynamic> bearerHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }
}
