import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_session.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  bool get canSubmit;

  @override
  List<Object?> get props => [];
}

final class LoginInitial extends LoginState {
  const LoginInitial();

  @override
  bool get canSubmit => false;
}

final class LoginEditing extends LoginState {
  const LoginEditing();

  @override
  bool get canSubmit => true;
}

final class LoginSubmitting extends LoginState {
  const LoginSubmitting();

  @override
  bool get canSubmit => false;
}

final class LoginFailure extends LoginState {
  const LoginFailure(this.message);

  final String message;

  @override
  bool get canSubmit => true;

  @override
  List<Object?> get props => [message];
}

final class LoginInvalidCredentials extends LoginState {
  const LoginInvalidCredentials([this.message = 'Incorrect email or password.']);

  final String message;

  @override
  bool get canSubmit => true;

  @override
  List<Object?> get props => [message];
}

final class LoginSuccess extends LoginState {
  const LoginSuccess(this.session);

  final AuthSession session;

  @override
  bool get canSubmit => false;

  @override
  List<Object?> get props => [session];
}

final class LoginMissingDatabase extends LoginState {
  const LoginMissingDatabase();

  @override
  bool get canSubmit => true;
}

final class LoginPasswordResetRequested extends LoginState {
  const LoginPasswordResetRequested(this.message);

  final String message;

  @override
  bool get canSubmit => true;

  @override
  List<Object?> get props => [message];
}

final class LoginPasswordResetFailure extends LoginState {
  const LoginPasswordResetFailure(this.message);

  final String message;

  @override
  bool get canSubmit => true;

  @override
  List<Object?> get props => [message];
}
