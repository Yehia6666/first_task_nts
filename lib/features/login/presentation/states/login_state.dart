import 'package:equatable/equatable.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/auth_session.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  bool get canSubmit;

  /// True while a request is running, so the form cannot be submitted again.
  bool get isBusy => false;

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

  @override
  bool get isBusy => true;
}

/// The token is stored and the account is being confirmed. The form stays put
/// and keeps the spinner on the button until the check comes back.
final class LoginVerifyingAccount extends LoginState {
  const LoginVerifyingAccount();

  @override
  bool get canSubmit => false;

  @override
  bool get isBusy => true;
}

/// The account behind the token cannot be used, so the token has been dropped.
/// Signing in again is the way forward.
final class LoginAccountRejected extends LoginState {
  const LoginAccountRejected({required this.reason, required this.message});

  final AccountRejection reason;
  final String message;

  @override
  bool get canSubmit => true;

  @override
  List<Object?> get props => [reason, message];
}

/// The check could not be completed. The token is kept, so trying again is
/// enough once the connection or the server is back.
final class LoginVerificationFailed extends LoginState {
  const LoginVerificationFailed(this.message);

  final String message;

  @override
  bool get canSubmit => true;

  @override
  List<Object?> get props => [message];
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
