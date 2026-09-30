import '../../../connection/domain/entities/database_url.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile({
    required String token,
    required DatabaseUrl databaseUrl,
  });
}
