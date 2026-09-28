import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/database_url.dart';
import '../models/validated_database_model.dart';

class DatabaseValidationRemoteDataSource {
  DatabaseValidationRemoteDataSource({
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

  static const String _validateDatabasePath = 'api/v1/auth/validate-database';

  Future<ValidatedDatabaseModel> validateDatabase(DatabaseUrl url) async {
    final Map<String, dynamic> payload = _payloadOf(
      await _post(
        url.endpoint(_validateDatabasePath),
        data: <String, dynamic>{'database_url': url.toString()},
      ),
    );

    final String? message = _stringOrNull(payload['message']);
    final String? code = _stringOrNull(payload['code']);

    // The API answers a rejected value with HTTP 200 and status "error", so the
    // status field decides the outcome, not the status code.
    if (payload['status'] != 'success') {
      throw ServerValidationFailure(
        message ?? 'The server could not validate this address.',
        code: code,
      );
    }

    final Object? data = payload['data'];
    if (data is! Map<String, dynamic> || data['database'] is! String) {
      throw const UnexpectedResponseFailure(
        'The server did not return a database for this address.',
      );
    }

    return ValidatedDatabaseModel.fromJson(
      data,
      requestedUrl: url,
      statusMessage: message,
    );
  }

  Future<Response<dynamic>> _post(
    String endpoint, {
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _dio.post<dynamic>(
        endpoint,
        data: data,
        options: Options(
          contentType: Headers.jsonContentType,
          // Error bodies carry the message the UI shows, so keep them.
          receiveDataWhenStatusError: true,
        ),
      );
    } on DioException catch (error) {
      throw _failureOf(error);
    }
  }

  Map<String, dynamic> _payloadOf(Response<dynamic> response) {
    final Object? decoded = _decoded(response.data);
    final Map<String, dynamic>? envelope =
        decoded is Map<String, dynamic> ? decoded : null;
    if (envelope == null) {
      throw const UnexpectedResponseFailure();
    }

    final Object? result = envelope['result'];
    return result is Map<String, dynamic> ? result : envelope;
  }

  Object? _decoded(Object? data) {
    if (data is! String) return data;
    try {
      return jsonDecode(data);
    } on FormatException {
      return null;
    }
  }

  String? _stringOrNull(Object? value) => value is String ? value : null;

  AppFailure _failureOf(DioException error) => switch (error.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.transformTimeout =>
          const TimeoutFailure(),
        DioExceptionType.badCertificate => const NetworkFailure(
            'The server certificate could not be verified. Check the address and try again.',
          ),
        DioExceptionType.badResponse => _responseFailure(error.response),
        DioExceptionType.cancel =>
          const NetworkFailure('The request was cancelled.'),
        // A body that claims to be JSON but is not is a bad answer, not a
        // broken connection.
        DioExceptionType.unknown when error.error is FormatException =>
          const UnexpectedResponseFailure(),
        DioExceptionType.connectionError || DioExceptionType.unknown =>
          const NetworkFailure(),
      };

  AppFailure _responseFailure(Response<dynamic>? response) {
    final int? statusCode = response?.statusCode;
    if (statusCode == null) {
      return const UnexpectedResponseFailure(
        'The server answered with an unexpected response. Make sure the address points to an Odoo server.',
      );
    }

    // Reuse the API's own message when the error body carries one.
    final String? reported = _reportedMessage(response?.data);

    return switch (statusCode) {
      404 => ServerRequestFailure(
          reported ??
              'This address does not expose the database validation API. Check that it points to an Odoo server.',
          statusCode: statusCode,
        ),
      401 || 403 => ServerRequestFailure(
          reported ?? 'The server refused the request (HTTP $statusCode).',
          statusCode: statusCode,
        ),
      >= 500 => ServerRequestFailure(
          reported ?? 'The server reported a problem (HTTP $statusCode).',
          statusCode: statusCode,
        ),
      _ => ServerRequestFailure(
          reported ?? 'The server answered with HTTP $statusCode.',
          statusCode: statusCode,
        ),
    };
  }

  String? _reportedMessage(Object? data) {
    final Object? decoded = _decoded(data);
    if (decoded is! Map<String, dynamic>) return null;

    final Object? result = decoded['result'];
    final Map<String, dynamic> payload =
        result is Map<String, dynamic> ? result : decoded;

    return _stringOrNull(payload['message']);
  }
}
