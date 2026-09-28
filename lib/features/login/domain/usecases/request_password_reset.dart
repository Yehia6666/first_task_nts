import '../../../connection/domain/entities/database_url.dart';
import '../repository/auth_repository.dart';

class RequestPasswordReset {
  const RequestPasswordReset(this._repository);

  final AuthRepository _repository;

  Future<String> call({required String email, required DatabaseUrl databaseUrl}) =>
      _repository.requestPasswordReset(email: email, databaseUrl: databaseUrl);
}
