import '../../../domain/entities/login_result.dart';

class LoginResultModel extends LoginResult {
  const LoginResultModel({
    required super.userId,
    required super.name,
    required super.email,
    required super.token,
    required super.database,
    required super.employeeId,
    required super.employeeName,
    required super.devicePlatform,
    required super.appVersion,
  });

  factory LoginResultModel.fromJson(Map<String, dynamic> json) {
    return LoginResultModel(
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse(json['user_id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      database: json['database']?.toString() ?? '',
      employeeId: json['employee_id'] is int
          ? json['employee_id'] as int
          : int.tryParse(json['employee_id']?.toString() ?? '') ?? 0,
      employeeName: json['employee_name']?.toString() ?? '',
      devicePlatform: json['device_platform']?.toString() ?? '',
      appVersion: json['app_version']?.toString() ?? '',
    );
  }
}
