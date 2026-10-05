import '../../../../core/errors/failure.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/utils/token_store.dart';
import '../../domain/entities/payslip_query.dart';
import '../../domain/entities/salary_attachment_query.dart';
import '../models/payslip_detail_model.dart';
import '../models/payslip_lines_model.dart';
import '../models/payslip_model.dart';
import '../models/payslip_worked_days_model.dart';
import '../models/salary_attachment_model.dart';
import 'payroll_remote_data_source.dart';

class PayrollRemoteDataSourceImp implements PayrollRemoteDataSource {
  const PayrollRemoteDataSourceImp(this._apiService, this._tokenStore);

  final ApiService _apiService;
  final TokenStore _tokenStore;

  static const String _payslips = '/api/v1/payroll/payslips';
  static const String _attachments = '/api/v1/payroll/salary-attachments';

  Future<Map<String, dynamic>> _getData(
    String token,
    String endPoint,
    String expectedKey, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final responseData = await _apiService.get(
      endPoint: endPoint,
      headers: _tokenStore.bearerHeaders(token),
      queryParameters: queryParameters,
    );

    final result =
        responseData['result'] as Map<String, dynamic>? ?? responseData;
    final data = result['data'] as Map<String, dynamic>? ?? result;

    if (data[expectedKey] == null) {
      final message = result['status'] == 'success' ? null : result['message'];
      throw ServerFaliure(
        message is String && message.isNotEmpty
            ? message
            : 'Unexpected payroll response from the server.',
      );
    }

    return data;
  }

  List<T> _models<T>(
    Map<String, dynamic> data,
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return (data[key] as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .map(fromJson)
        .toList();
  }

  @override
  Future<List<PayslipModel>> getPayslips({
    required String token,
    required PayslipQuery query,
  }) async {
    final data = await _getData(
      token,
      _payslips,
      'payslips',
      queryParameters: {
        if (query.dateFromMin != null) 'date_from_min': query.dateFromMin,
        if (query.dateFromMax != null) 'date_from_max': query.dateFromMax,
        'limit': query.limit,
        'offset': query.offset,
      },
    );

    return _models(data, 'payslips', PayslipModel.fromJson);
  }

  @override
  Future<PayslipDetailModel> getPayslip({
    required String token,
    required int payslipId,
  }) async {
    final data = await _getData(token, '$_payslips/$payslipId', 'id');

    return PayslipDetailModel.fromJson(data);
  }

  @override
  Future<PayslipWorkedDaysModel> getPayslipWorkedDays({
    required String token,
    required int payslipId,
  }) async {
    final data = await _getData(
      token,
      '$_payslips/$payslipId/worked_days',
      'worked_days',
    );

    return PayslipWorkedDaysModel.fromJson(data);
  }

  @override
  Future<PayslipLinesModel> getPayslipLines({
    required String token,
    required int payslipId,
  }) async {
    final data = await _getData(token, '$_payslips/$payslipId/lines', 'lines');

    return PayslipLinesModel.fromJson(data);
  }

  @override
  Future<List<int>> getPayslipPdf({
    required String token,
    required int payslipId,
  }) {
    return _apiService.getBytes(
      endPoint: '$_payslips/$payslipId/pdf',
      headers: _tokenStore.bearerHeaders(token),
    );
  }

  @override
  Future<List<SalaryAttachmentModel>> getSalaryAttachments({
    required String token,
    required SalaryAttachmentQuery query,
  }) async {
    final data = await _getData(
      token,
      _attachments,
      'salary_attachments',
      queryParameters: {
        'state': query.state,
        'limit': query.limit,
        'offset': query.offset,
      },
    );

    return _models(data, 'salary_attachments', SalaryAttachmentModel.fromJson);
  }

  @override
  Future<SalaryAttachmentModel> getSalaryAttachment({
    required String token,
    required int attachmentId,
  }) async {
    final data = await _getData(token, '$_attachments/$attachmentId', 'id');

    return SalaryAttachmentModel.fromJson(data);
  }
}
