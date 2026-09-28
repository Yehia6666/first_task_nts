import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

import '../../../connection/domain/entities/database_url.dart';
import '../models/forgot_password_request_model.dart';
import '../models/message_response_model.dart';
import '../models/sign_in_request_model.dart';
import '../models/sign_in_response_model.dart';
import 'auth_payload_mapper.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({
    Dio? dio,
    this.timeout = const Duration(seconds: 15),
  }) : _dio = dio ?? Dio() {
    _dio.options
      ..connectTimeout ??= timeout
      ..sendTimeout ??= timeout
      ..receiveTimeout ??= timeout;
  }

  final Dio _dio;
  final Duration timeout;
  final AuthPayloadMapper _mapper = const AuthPayloadMapper();

  static const String _signInPath = 'api/v1/auth/signin';
  static const String _forgotPasswordPath = 'api/v1/auth/forgot-password';

  Future<SignInResponseModel> signIn({
    required String email,
    required String password,
    required DatabaseUrl databaseUrl,
  }) async {
    final Map<String, dynamic> payload = _mapper.payloadOf(
      await _post(
        databaseUrl,
        _signInPath,
        data: SignInRequestModel(
          email: email,
          password: password,
          databaseUrl: databaseUrl,
          devicePlatform: _devicePlatform(),
        ).toJson(),
      ),
    );

    if (_mapper.isRejected(payload)) {
      throw _mapper.rejectionOf(payload, fallback: 'Could not sign in. Please try again.');
    }

    final SignInResponseModel? session =
        SignInResponseModel.fromJson(_mapper.resourceOf(payload));
    if (session != null) return session;

    throw _mapper.rejectionOf(payload, fallback: 'The server did not return a session token.');
  }

  Future<String> forgotPassword({
    required String email,
    required DatabaseUrl databaseUrl,
  }) async {
    final Map<String, dynamic> payload = _mapper.payloadOf(
      await _post(
        databaseUrl,
        _forgotPasswordPath,
        data: ForgotPasswordRequestModel(email: email).toJson(),
      ),
    );

    if (_mapper.isRejected(payload)) {
      throw _mapper.rejectionOf(
        payload,
        fallback: 'The server could not start the password reset.',
      );
    }

    return MessageResponseModel.fromJson(payload).message ??
        'If this address belongs to an account, a reset link is on its way.';
  }

  Future<Response<dynamic>> _post(
    DatabaseUrl databaseUrl,
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _dio.post<dynamic>(
        databaseUrl.endpoint(path),
        data: data,
        options: Options(
          contentType: Headers.jsonContentType,
          // Error bodies carry the message the UI shows, so keep them.
          receiveDataWhenStatusError: true,
        ),
      );
    } on DioException catch (error) {
      throw _mapper.failureOf(error);
    }
  }

  static String _devicePlatform() {
    if (kIsWeb) return 'web';
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      _ => 'web',
    };
  }
}