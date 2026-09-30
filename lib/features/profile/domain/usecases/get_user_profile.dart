import '../../../../core/errors/app_failure.dart';
import '../../../connection/domain/entities/database_url.dart';
import '../../../connection/domain/usecases/get_saved_database_url.dart';
import '../../../login/domain/repository/auth_repository.dart';
import '../entities/user_profile.dart';
import '../repository/profile_repository.dart';

class GetUserProfile {
  const GetUserProfile(
    this._repository,
    this._authRepository,
    this._getSavedDatabaseUrl,
  );

  final ProfileRepository _repository;
  final AuthRepository _authRepository;
  final GetSavedDatabaseUrl _getSavedDatabaseUrl;

  Future<UserProfile> call() async {
    final String? token = await _authRepository.loadAuthToken();
    if (token == null || token.isEmpty) {
      throw const AccountRejectedFailure(
        'You are not signed in, so your profile cannot be loaded. Please sign in again.',
        reason: AccountRejection.sessionExpired,
      );
    }

    final DatabaseUrl? databaseUrl = await _getSavedDatabaseUrl();
    if (databaseUrl == null) {
      throw const UnexpectedResponseFailure(
        'No server address is saved, so your profile cannot be loaded. Save the server address first.',
      );
    }

    return _repository.getProfile(token: token, databaseUrl: databaseUrl);
  }
}
