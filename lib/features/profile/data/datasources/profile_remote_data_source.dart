import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/token_store.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile({required String token});
}

class ProfileRemoteDataSourceImp implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImp(this._apiService, this._tokenStore);

  final ApiService _apiService;
  final TokenStore _tokenStore;

  @override
  Future<ProfileModel> getProfile({required String token}) async {
    final responseData = await _apiService.get(
      endPoint: '/api/v1/auth/profile',
      headers: _tokenStore.bearerHeaders(token),
    );

    final result =
        responseData['result'] as Map<String, dynamic>? ?? responseData;

    return ProfileModel.fromJson(result);
  }
}