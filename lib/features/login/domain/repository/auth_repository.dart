import '../../../connection/domain/entities/database_url.dart';
import '../entities/auth_session.dart';
import '../entities/authenticated_user.dart';

abstract class AuthRepository {
  Future<AuthSession> signIn({
    required String email,
    required String password,
    required DatabaseUrl databaseUrl,
  });

  Future<String> requestPasswordReset({
    required String email,
    required DatabaseUrl databaseUrl,
  });

  /// Reads the account behind [token] from the current-user endpoint.
  Future<AuthenticatedUser> loadCurrentUser({
    required String token,
    required DatabaseUrl databaseUrl,
  });

  Future<void> saveAuthToken(String token);

  Future<String?> loadAuthToken();

  Future<void> clearAuthToken();
}
