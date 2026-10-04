import '../../../domain/entities/login_response.dart';
import 'login_result_model.dart';

class LoginResponseModel extends LoginResponse {
  const LoginResponseModel({
    required super.status,
    required super.code,
    required super.message,
    required super.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: LoginResultModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}
