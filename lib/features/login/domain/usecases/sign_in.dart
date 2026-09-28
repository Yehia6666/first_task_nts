import '../../../connection/domain/entities/database_url.dart';
import '../entities/auth_session.dart';
import '../repository/auth_repository.dart';

class SignIn {
  const SignIn(this._repository);

  final AuthRepository _repository;

  Future<AuthSession> call({
    required String email,
    required String password,
    required DatabaseUrl databaseUrl,
  }) =>
      _repository.signIn(email: email, password: password, databaseUrl: databaseUrl);
}
