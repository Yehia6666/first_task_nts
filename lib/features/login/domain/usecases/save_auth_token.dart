import '../repository/auth_repository.dart';

class SaveAuthToken {
  const SaveAuthToken(this._repository);

  final AuthRepository _repository;

  Future<void> call(String token) => _repository.saveAuthToken(token);
}
