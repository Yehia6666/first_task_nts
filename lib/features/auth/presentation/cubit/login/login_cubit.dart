import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/login_response.dart';
import '../../../domain/usecases/sign_in_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.signInUseCase}) : super(LoginInitial());

  final SignInUseCase signInUseCase;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    final result = await signInUseCase.call((email, password));
    log('LoginCubit');
    result.fold(
      (failure) => emit(LoginFailure(failure.errorMessage)),
      (response) {
        if (response.isSuccess) {
          emit(LoginSuccess(response));
        } else {
          emit(LoginFailure(response.message));
        }
      },
    );
  }
}
