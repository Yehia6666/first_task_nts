import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../connection/domain/entities/database_url.dart';
import '../../../connection/domain/usecases/get_saved_database_url.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/usecases/request_password_reset.dart';
import '../../domain/usecases/save_auth_token.dart';
import '../../domain/usecases/sign_in.dart';
import '../states/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.signIn,
    required this.requestPasswordReset,
    required this.saveAuthToken,
    required this.getSavedDatabaseUrl,
  }) : super(const LoginInitial());

  final SignIn signIn;
  final RequestPasswordReset requestPasswordReset;
  final SaveAuthToken saveAuthToken;
  final GetSavedDatabaseUrl getSavedDatabaseUrl;

  Future<void> signInWith({
    required String email,
    required String password,
  }) async {
    emit(const LoginSubmitting());

    final DatabaseUrl? databaseUrl = await getSavedDatabaseUrl();
    if (isClosed) return;
    if (databaseUrl == null) {
      emit(const LoginMissingDatabase());
      return;
    }

    try {
      final AuthSession session =
          await signIn(email: email, password: password, databaseUrl: databaseUrl);
      await saveAuthToken(session.token);
      if (isClosed) return;
      emit(LoginSuccess(session));
    } on AppFailure catch (failure) {
      if (isClosed) return;
      emit(_failureOf(failure));
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
