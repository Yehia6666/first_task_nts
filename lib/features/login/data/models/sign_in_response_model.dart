import '../../domain/entities/auth_session.dart';

class SignInResponseModel extends AuthSession {
  const SignInResponseModel({
    required super.token,
    super.userName,
    super.database,
  });

  static SignInResponseModel? fromJson(Map<String, dynamic> json) {
    final String? token = _stringOf(json, const <String>['token', 'access_token', 'jwt']);
    if (token == null) return null;

    return SignInResponseModel(
      token: token,
      userName: _stringOf(
        json,
        const <String>['user_name', 'name', 'full_name', 'login', 'email'],
        nestedKey: 'user',
      ),
      database: _stringOf(json, const <String>['db', 'database']),
    );
  }

  static String? _stringOf(
    Map<String, dynamic> json,
    List<String> keys, {
    String? nestedKey,
  }) {
    for (final String key in keys) {
      final Object? value = json[key];
      if (value is String && value.isNotEmpty) return value;
    }

    if (nestedKey != null && json[nestedKey] is Map<String, dynamic>) {
      return _stringOf(json[nestedKey] as Map<String, dynamic>, keys);
    }
    return null;
  }
}
