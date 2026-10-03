import 'package:dio/dio.dart';

class ApiService {
  final _baseUrl = 'https://odoo.example.com';
  final Dio _dio;

  ApiService(this._dio);
  Future<Map<String, dynamic>> get(
      {required String endPoint, Map<String, dynamic>? headers}) async {
    var response = await _dio.get(
      '$_baseUrl$endPoint',
      options: Options(
        headers: headers,
      ),
    );

    return response.data;
  }

  Future<dynamic> postWithBody(
      {required String endpoint,
      required Map<String, dynamic> data,
      required Map<String, dynamic> headers}) async {
    var response = await _dio.post(
      '$_baseUrl$endpoint',
      data: data,
      options: Options(
        headers: headers,
      ),
    );
    return response;
  }
}