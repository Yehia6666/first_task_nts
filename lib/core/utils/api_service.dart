import 'package:dio/dio.dart';

class ApiService {
  final _baseUrl = 'https://aalmosa-staging.odoo.com';
  final Dio _dio;

  ApiService(this._dio);
  Future<Map<String, dynamic>> get({
    required String endPoint,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.get(
      '$_baseUrl$endPoint',
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );

    return response.data;
  }

  /// Fetches a binary body, used by the endpoints that answer with a file
  /// instead of JSON (the payslip PDF).
  Future<List<int>> getBytes({
    required String endPoint,
    required Map<String, dynamic> headers,
  }) async {
    var response = await _dio.get<List<int>>(
      '$_baseUrl$endPoint',
      options: Options(headers: headers, responseType: ResponseType.bytes),
    );

    return response.data ?? const [];
  }

  Future<dynamic> postWithBody({
    required String endpoint,
    required Map<String, dynamic> data,
    required Map<String, dynamic> headers,
  }) async {
    var response = await _dio.post(
      '$_baseUrl$endpoint',
      data: data,
      options: Options(headers: headers),
    );
    return response;
  }
}
