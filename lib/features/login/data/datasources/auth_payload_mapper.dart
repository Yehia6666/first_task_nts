import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/errors/app_failure.dart';
import '../models/message_response_model.dart';

class AuthPayloadMapper {
  const AuthPayloadMapper();

  static const String sessionActiveCode = 'session_active';
  static const String sessionActiveMessage =
      'This account is already signed in on another device. '
      'Please log out there first, or wait until the session expires.';

  Map<String, dynamic> payloadOf(Response<dynamic> response) {
    final Object? decoded = decode(response.data);
    final Map<String, dynamic>? envelope =
        decoded is Map<String, dynamic> ? decoded : null;
    if (envelope == null) {
      throw const UnexpectedResponseFailure();
    }

    final Object? result = envelope['result'];
    return result is Map<String, dynamic> ? result : envelope;
  }

  Map<String, dynamic> resourceOf(Map<String, dynamic> payload) {
    final Object? data = payload['data'];
    return data is Map<String, dynamic> ? data : payload;
  }

  bool isRejected(Map<String, dynamic> payload) {
    final Object? status = payload['status'];
    return status is String && status != 'success';
  }

  AppFailure rejectionOf(
    Map<String, dynamic> payload, {
    required String fallback,
  }) {
    final MessageResponseModel rejection = MessageResponseModel.fromJson(payload);

    if (rejection.code == sessionActiveCode) {
      return ServerValidationFailure(sessionActiveMessage, code: rejection.code);
    }
    return ServerValidationFailure(rejection.message ?? fallback, code: rejection.code);
  }

  Object? decode(Object? data) {
    if (data is! String) return data;
    try {
      return jsonDecode(data);
    } on FormatException {
      return null;
    }
  }

  AppFailure failureOf(DioException error) => switch (error.type) {
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
      return const UnexpectedResponseFailure();
    }

    // Reuse the API's own message when the error body carries one.
    final String? reported = reportedMessage(response?.data);

    return switch (statusCode) {
      404 => ServerRequestFailure(
          reported ??
              'This address does not expose the authentication API. Check that it points to an Odoo server.',
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

  String? reportedMessage(Object? data) {
    final Object? decoded = decode(data);
    if (decoded is! Map<String, dynamic>) return null;

    final Object? result = decoded['result'];
    return MessageResponseModel.fromJson(
      result is Map<String, dynamic> ? result : decoded,
    ).message;
  }
}