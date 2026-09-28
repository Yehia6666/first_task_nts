import '../../../../core/constants/app_config.dart';
import '../../../connection/domain/entities/database_url.dart';

class SignInRequestModel {
  const SignInRequestModel({
    required this.email,
    required this.password,
    required this.databaseUrl,
    required this.devicePlatform,
    this.appVersion = AppConfig.appVersion,
  });

  final String email;
  final String password;
  final DatabaseUrl databaseUrl;

  final String devicePlatform;
  final String appVersion;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'password': password,
        'database_url': databaseUrl.toString(),
        'device_platform': devicePlatform,
        'app_version': appVersion,
      };
}
