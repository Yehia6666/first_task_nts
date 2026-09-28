import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.token,
    this.userName,
    this.database,
  });

  final String token;

  final String? userName;

  final String? database;

  @override
  List<Object?> get props => [token, userName, database];
}
