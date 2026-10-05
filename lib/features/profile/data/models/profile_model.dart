import '../../domain/entities/profile.dart';

/// Maps the profile payload onto [Profile].
///
/// The endpoint uses the same two-layer envelope as the other auth calls: the
/// remote data source unwraps `result`, and the payload itself then sits under
/// `data` (as in `LoginResponseModel` / `DatabaseValidationModel`). Within the
/// payload, user fields may sit at the top level or under `user`, and employee
/// fields under `employee`. Each lookup falls back to the enclosing level, so
/// flattened and nested payloads both parse.
class ProfileModel extends Profile {
  const ProfileModel({
    required super.name,
    required super.email,
    required super.phone,
    required super.company,
    required super.department,
    required super.employeeId,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final user = data['user'] as Map<String, dynamic>? ?? data;
    final employee = user['employee'] as Map<String, dynamic>? ?? data;

    return ProfileModel(
      name: user['name']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      phone: user['phone']?.toString() ?? '',
      company: _read(employee, user, 'company'),
      department: _read(employee, user, 'department'),
      employeeId: _read(employee, user, 'employee_id'),
    );
  }

  /// Prefers the nested employee value, then the enclosing level, then ''.
  static String _read(
    Map<String, dynamic> employee,
    Map<String, dynamic> fallback,
    String key,
  ) {
    return employee[key]?.toString() ?? fallback[key]?.toString() ?? '';
  }
}