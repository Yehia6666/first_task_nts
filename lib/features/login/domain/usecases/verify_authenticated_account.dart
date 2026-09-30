import '../../../../core/errors/app_failure.dart';
import '../../../connection/domain/entities/database_url.dart';
import '../entities/authenticated_user.dart';
import '../repository/auth_repository.dart';

/// Confirms that the token which was just stored belongs to an account the app
/// may open. Throws an [AccountRejectedFailure] when the account cannot be used,
/// and any other [AppFailure] when the check itself could not be completed.
class VerifyAuthenticatedAccount {
  const VerifyAuthenticatedAccount(this._repository);

  final AuthRepository _repository;

  Future<AuthenticatedUser> call({required DatabaseUrl databaseUrl}) async {
    final String? token = await _repository.loadAuthToken();
    if (token == null || token.isEmpty) {
      throw const AccountRejectedFailure(
        'No session was stored, so the account could not be verified. Please sign in again.',
        reason: AccountRejection.sessionExpired,
      );
    }

    final AuthenticatedUser user = await _repository.loadCurrentUser(
      token: token,
      databaseUrl: databaseUrl,
    );

    if (user.isDeleted) {
      throw const AccountRejectedFailure(
        'This account has been deleted. Contact your administrator to have it restored.',
        reason: AccountRejection.accountDeleted,
      );
    }

    if (!user.isActive) {
      throw const AccountRejectedFailure(
        'This account is disabled or blocked. Contact your administrator to have it enabled again.',
        reason: AccountRejection.accountDisabled,
      );
    }

    if (!user.hasRequiredProfile) {
      throw const AccountRejectedFailure(
        'Your profile is incomplete. Add your name and email address, then sign in again.',
        reason: AccountRejection.profileIncomplete,
      );
    }

    return user;
  }
}
