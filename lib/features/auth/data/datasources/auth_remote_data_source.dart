import 'package:flutter/foundation.dart';

import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/token_store.dart';
import '../models/server_model/database_validation_model.dart';
import '../models/login_model/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<DatabaseValidationModel> validateDatabase(String databaseUrl);

  Future<LoginResponseModel> signIn({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImp(this._apiService, this._tokenStore);

  final ApiService _apiService;
  final TokenStore _tokenStore;

  @override
  Future<DatabaseValidationModel> validateDatabase(String databaseUrl) async {
    final response = await _apiService.postWithBody(
      endpoint: '/api/v1/auth/validate-database',
      data: {'database_url': databaseUrl},
      headers: {'Content-Type': 'application/json'},
    );
    final responseData = response.data as Map<String, dynamic>;
    final resultData =
        responseData['result'] as Map<String, dynamic>? ?? responseData;
    return DatabaseValidationModel.fromJson(resultData);
  }

  @override
  Future<LoginResponseModel> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.postWithBody(
      endpoint: '/api/v1/auth/signin',
      data: {
        'email': email,
        'password': password,
        'device_platform': defaultTargetPlatform.name,
      },
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = response.data as Map<String, dynamic>;
    final resultData =
        responseData['result'] as Map<String, dynamic>? ?? responseData;
    final loginResponse = LoginResponseModel.fromJson(resultData);

    // Persist only on a genuinely successful sign-in: a failed request throws
    // before this point, and a non-success payload stores nothing.
    if (loginResponse.isSuccess && loginResponse.data.token.isNotEmpty) {
      await _tokenStore.save(loginResponse.data.token);
    }

    return loginResponse;
  }
}
