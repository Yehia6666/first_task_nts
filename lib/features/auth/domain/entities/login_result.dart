import 'package:equatable/equatable.dart';

class LoginResult extends Equatable {
  const LoginResult({
    required this.userId,
    required this.name,
    required this.email,
    required this.token,
    required this.database,
    required this.employeeId,
    required this.employeeName,
    required this.devicePlatform,
    required this.appVersion,
  });

  final int userId;
  final String name;
  final String email;
  final String token;
  final String database;
  final int employeeId;
  final String employeeName;
  final String devicePlatform;
  final String appVersion;

  @override
  List<Object> get props => [
        userId,
        name,
        email,
        token,
        database,
        employeeId,
        employeeName,
        devicePlatform,
        appVersion,
      ];
}
