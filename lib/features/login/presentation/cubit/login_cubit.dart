import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../connection/domain/entities/database_url.dart';
import '../../../connection/domain/usecases/get_saved_database_url.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/usecases/clear_auth_token.dart';
import '../../domain/usecases/request_password_reset.dart';
import '../../domain/usecases/save_auth_token.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/verify_authenticated_account.dart';
import '../states/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.signIn,
    required this.requestPasswordReset,
    required this.saveAuthToken,
    required this.getSavedDatabaseUrl,
    required this.verifyAuthenticatedAccount,
    required this.clearAuthToken,
  }) : super(const LoginInitial());

  final SignIn signIn;
  final RequestPasswordReset requestPasswordReset;
  final SaveAuthToken saveAuthToken;
  final GetSavedDatabaseUrl getSavedDatabaseUrl;
  final VerifyAuthenticatedAccount verifyAuthenticatedAccount;
  final ClearAuthToken clearAuthToken;

  Future<void> signInWith({
    required String email,
    required String password,
  }) async {
    // A second tap while the first request is still running changes nothing.
    if (state.isBusy) return;
    emit(const LoginSubmitting());

    final DatabaseUrl? databaseUrl = await getSavedDatabaseUrl();
    if (isClosed) return;
    if (databaseUrl == null) {
      emit(const LoginMissingDatabase());
      return;
    }

    final AuthSession? session = await _openSession(
      email: email,
      password: password,
      databaseUrl: databaseUrl,
    );
    if (isClosed || session == null) return;

    // The credentials are good, but the account still has to clear the checks
    // before the shell is allowed to open.
    emit(const LoginVerifyingAccount());
    final bool verified = await _verifyAccount(databaseUrl);
    if (isClosed || !verified) return;

    emit(LoginSuccess(session));
  }

  /// Signs in and stores the token. Returns null when the state already carries
  /// the reason the attempt failed.
  Future<AuthSession?> _openSession({
    required String email,
    required String password,
    required DatabaseUrl databaseUrl,
  }) async {
    try {
      final AuthSession session =
          await signIn(email: email, password: password, databaseUrl: databaseUrl);
      await saveAuthToken(session.token);
      return session;
    } on AppFailure catch (failure) {
      if (isClosed) return null;
      emit(_failureOf(failure));
      return null;
    }
  }

  /// Returns false when the state already carries the reason the account was
  /// refused, or why the check could not be completed.
  Future<bool> _verifyAccount(DatabaseUrl databaseUrl) async {
    try {
      await verifyAuthenticatedAccount(databaseUrl: databaseUrl);
      return true;
    } on AccountRejectedFailure catch (failure) {
      // The token the server just issued is worthless, so do not keep it.
      await clearAuthToken();
      if (isClosed) return false;
      emit(LoginAccountRejected(reason: failure.reason, message: failure.message));
      return false;
    } on AppFailure catch (failure) {
      if (isClosed) return false;
      emit(LoginVerificationFailed(failure.message));
      return false;
    } on TimeoutException {
      if (isClosed) return false;
      emit(const LoginVerificationFailed(
        'The server took too long to confirm your account. Check your connection and try again.',
      ));
      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    final DatabaseUrl? databaseUrl = await getSavedDatabaseUrl();
    if (isClosed) return;
    if (databaseUrl == null) {
      emit(const LoginMissingDatabase());
      return;
    }

    try {
      final String message =
          await requestPasswordReset(email: email, databaseUrl: databaseUrl);
      if (isClosed) return;
      emit(LoginPasswordResetRequested(message));
    } on AppFailure catch (failure) {
      if (isClosed) return;
      emit(LoginPasswordResetFailure(failure.message));
    }
  }

  void onFormEdited() => emit(const LoginEditing());

  LoginState _failureOf(AppFailure failure) => switch (failure) {
        ServerValidationFailure(message: final message) => LoginInvalidCredentials(message),
        _ => LoginFailure(failure.message),
      };
}
