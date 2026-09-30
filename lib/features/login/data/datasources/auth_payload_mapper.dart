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
          const TimeoutFailure('Connection timed out.'),
        DioExceptionType.badCertificate => const NetworkFailure(
            'The server certificate could not be verified. Check the address and try again.',
          ),
        DioExceptionType.badResponse => _responseFailure(error.response),
        DioExceptionType.cancel =>
          const NetworkFailure('The request was cancelled.'),
        DioExceptionType.unknown when error.error is FormatException =>
          const UnexpectedResponseFailure(),
        DioExceptionType.connectionError => const NetworkFailure(
            'No internet connection. Check your network and try again.',
          ),
        _ => const NetworkFailure(
            'The connection to the server failed. Check the address and your internet connection.',
          ),
      };

  AppFailure _responseFailure(Response<dynamic>? response) {
    final int? statusCode = response?.statusCode;
    if (statusCode == null) {
      return const UnexpectedResponseFailure();
    }

    final String? reported = reportedMessage(response?.data);

    return switch (statusCode) {
      401 || 403 => ServerRequestFailure(
          reported ?? 'The server refused the request (HTTP $statusCode).',
          statusCode: statusCode,
        ),
      404 => ServerRequestFailure(
          reported ??
              'The server has no authentication endpoint at this address. Check the server URL.',
          statusCode: statusCode,
        ),
      405 => ServerRequestFailure(
          reported ??
              'The server does not accept this request method for the authentication endpoint.',
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