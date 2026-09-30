import '../repository/auth_repository.dart';

class ClearAuthToken {
  const ClearAuthToken(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.clearAuthToken();
}
