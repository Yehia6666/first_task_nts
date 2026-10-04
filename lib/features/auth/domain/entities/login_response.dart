import 'package:equatable/equatable.dart';

import 'login_result.dart';

class LoginResponse extends Equatable {
  const LoginResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  final String status;
  final String code;
  final String message;
  final LoginResult data;

  bool get isSuccess => code == 'success';

  @override
  List<Object> get props => [status, code, message, data];
}
