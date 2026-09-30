import '../../domain/entities/authenticated_user.dart';

class AuthenticatedUserModel extends AuthenticatedUser {
  const AuthenticatedUserModel({
    required super.name,
    required super.email,
    super.id,
    super.phone,
    super.role,
    super.isActive,
    super.isDeleted,
    super.isEmailVerified,
  });

  /// Reads the account out of the resource of the current-user payload. Every
  /// key is optional: the server decides which of them it publishes, and the
  /// account rules are applied afterwards on what is actually here.
  static AuthenticatedUserModel? fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> profile = _profileOf(json);

    final String? name = _stringOf(
      profile,
      const <String>['name', 'user_name', 'full_name', 'display_name', 'login'],
    );
    final String? email = _stringOf(
      profile,
      const <String>['email', 'mail', 'email_address'],
    );
    if (name == null || email == null) return null;

    return AuthenticatedUserModel(
      id: _intOf(profile, const <String>['id', 'user_id', 'employee_id']),
      name: name,
      email: email,
      phone: _stringOf(profile, const <String>['phone', 'mobile', 'phone_number']),
      role: _stringOf(profile, const <String>['role', 'job_title', 'position']),
      isActive: _isActiveOf(profile),
      isDeleted: _boolOf(profile, const <String>['is_deleted', 'deleted', 'archived']) ?? false,
      isEmailVerified: _boolOf(
        profile,
        const <String>['is_email_verified', 'email_verified', 'verified'],
      ),
    );
  }

  /// The account may sit one level down under `user` or `profile`.
  static Map<String, dynamic> _profileOf(Map<String, dynamic> json) {
    for (final String key in const <String>['user', 'profile', 'account']) {
      final Object? nested = json[key];
      if (nested is Map<String, dynamic>) return nested;
    }
    return json;
  }

  static bool _isActiveOf(Map<String, dynamic> json) {
    final String? status = _stringOf(
      json,
      const <String>['status', 'state', 'account_status'],
    )?.toLowerCase();
    if (status != null) {
      return switch (status) {
        'active' || 'enabled' || 'confirmed' => true,
        'inactive' || 'disabled' || 'blocked' || 'banned' || 'suspended' => false,
        _ => _boolOf(json, const <String>['is_active', 'active', 'enabled']) ?? true,
      };
    }
    return _boolOf(json, const <String>['is_active', 'active', 'enabled']) ?? true;
  }

  static String? _stringOf(Map<String, dynamic> json, List<String> keys) {
    for (final String key in keys) {
      final Object? value = json[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  static int? _intOf(Map<String, dynamic> json, List<String> keys) {
    for (final String key in keys) {
      final Object? value = json[key];
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
    }
    return null;
  }

  static bool? _boolOf(Map<String, dynamic> json, List<String> keys) {
    for (final String key in keys) {
      final Object? value = json[key];
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final String text = value.trim().toLowerCase();
        if (text == 'true' || text == '1') return true;
        if (text == 'false' || text == '0') return false;
      }
    }
    return null;
  }
}
