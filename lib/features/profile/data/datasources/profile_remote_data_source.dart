import 'package:dio/dio.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../connection/domain/entities/database_url.dart';
import '../../../login/data/datasources/auth_payload_mapper.dart';
import '../../domain/entities/user_profile.dart';
import '../models/user_profile_model.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource({
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

  static const String _profilePath = 'api/v1/auth/profile';

  Future<UserProfileModel> getProfile({
    required String token,
    required DatabaseUrl databaseUrl,
  }) async {
    try {
      final Map<String, dynamic> payload = _mapper.payloadOf(
        await _get(databaseUrl, token),
      );

      if (_mapper.isRejected(payload)) {
        throw _mapper.rejectionOf(
          payload,
          fallback: 'The server could not return your profile.',
        );
      }

      final UserProfileModel? profile =
          UserProfileModel.fromJson(_mapper.resourceOf(payload));
      if (profile == null) {
        throw const UnexpectedResponseFailure(
          'The server did not return your profile details.',
        );
      }

      return profile.withEmployee(
        _withResolvedImage(profile.employee, databaseUrl),
      );
    } on AppFailure catch (failure) {
      throw _refusedTokenAs(failure);
    }
  }

  Future<Response<dynamic>> _get(
    DatabaseUrl databaseUrl,
    String token,
  ) async {
    try {
      return await _dio.get<dynamic>(
        databaseUrl.endpoint(_profilePath),
        options: Options(
          headers: <String, dynamic>{'Authorization': 'Bearer $token'},
          receiveDataWhenStatusError: true,
        ),
      );
    } on DioException catch (error) {
      throw _mapper.failureOf(error);
    }
  }

  static EmployeeProfile? _withResolvedImage(
    EmployeeProfile? employee,
    DatabaseUrl databaseUrl,
  ) {
    final String? image = employee?.imageUrl;
    if (employee == null || image == null || image.isEmpty) return employee;

    final Uri base = databaseUrl.value;
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return employee;
    }

    final String origin = '${base.scheme}://${base.host}'
        '${base.hasPort ? ':${base.port}' : ''}';
    final String path = image.startsWith('/') ? image : '/$image';
    return EmployeeModel(
      id: employee.id,
      code: employee.code,
      name: employee.name,
      imageUrl: '$origin$path',
      gender: employee.gender,
      birthday: employee.birthday,
      jobTitle: employee.jobTitle,
      department: employee.department,
      division: employee.division,
      company: employee.company,
      jobPosition: employee.jobPosition,
      reference: employee.reference,
      workEmail: employee.workEmail,
      workPhone: employee.workPhone,
      workMobile: employee.workMobile,
    );
  }

  static AppFailure _refusedTokenAs(AppFailure failure) {
    if (failure is ServerRequestFailure &&
        (failure.statusCode == 401 || failure.statusCode == 403)) {
      return const AccountRejectedFailure(
        'Your session is no longer valid. Please sign in again.',
        reason: AccountRejection.sessionExpired,
      );
    }
    return failure;
  }
}
