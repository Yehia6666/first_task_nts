import 'dart:developer' as developer;
import 'dart:io';
import '../../../../core/utils/api_service.dart';
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
  const AuthRemoteDataSourceImp(this._apiService);

  final ApiService _apiService;

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
        'device_platform': Platform.operatingSystem,
      },
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = response.data as Map<String, dynamic>;
    final resultData =
        responseData['result'] as Map<String, dynamic>? ?? responseData;
    return LoginResponseModel.fromJson(resultData);
  }
}
