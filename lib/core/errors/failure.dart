import 'package:dio/dio.dart';

abstract class Failure {
  final String errorMessage;

  Failure(this.errorMessage);
}

class ServerFaliure extends Failure {
  ServerFaliure(super.errorMessage);

  factory ServerFaliure.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFaliure('Connection timeout with api Server');
      case DioExceptionType.sendTimeout:
        return ServerFaliure('Send timeout woth ApiServer');
      case DioExceptionType.receiveTimeout:
        return ServerFaliure('Receive timeout with ApiServer');
      case DioExceptionType.badCertificate:
        return ServerFaliure('badCertificate with APiServer');
      case DioExceptionType.badResponse:
        print('=== DIO DEBUG ===');
        print('URI: ${e.requestOptions.uri}');
        print('Method: ${e.requestOptions.method}');
        print('Status: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
        print('Response data type: ${e.response?.data.runtimeType}');
        print('=== END DIO DEBUG ===');
        return ServerFaliure.fromResponse(
          e.response!.statusCode!,
          e.response!.data,
        );
      case DioExceptionType.cancel:
        return ServerFaliure('Request to ApiServer was Canceld');
      case DioExceptionType.connectionError:
        return ServerFaliure('No Internet Connection');
      case DioExceptionType.unknown:
        return ServerFaliure('Opps There was an Error, Please try again');
      case DioExceptionType.transformTimeout:
        return ServerFaliure('Time is end, Please try again');
    }
  }

  factory ServerFaliure.fromResponse(int statusCode, dynamic response) {
    final apiMessage = _extractMessage(response);
    if (apiMessage != null) {
      return ServerFaliure(apiMessage);
    }
    if (statusCode == 404) {
      return ServerFaliure('Your request was not found, Please try later');
    } else if (statusCode == 500) {
      return ServerFaliure('There is a Problem with server, Please try Later');
    } else if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFaliure('No Paramters');
    } else {
      return ServerFaliure('There was an error, Please try again');
    }
  }

  static String? _extractMessage(dynamic response) {
    if (response is Map<String, dynamic>) {
      final message = response['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    return null;
  }
}
