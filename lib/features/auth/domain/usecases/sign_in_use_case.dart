import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/login_response.dart';
import 'auth_repository.dart';

class SignInUseCase extends UseCase<LoginResponse, (String, String)> {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, LoginResponse>> call((String, String) param) {
    return _repository.signIn(
      email: param.$1,
      password: param.$2,
    );
  }
}
