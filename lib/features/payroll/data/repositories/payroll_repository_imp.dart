import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/payslip.dart';
import '../../domain/entities/payslip_detail.dart';
import '../../domain/entities/payslip_lines.dart';
import '../../domain/entities/payslip_query.dart';
import '../../domain/entities/payslip_worked_days.dart';
import '../../domain/entities/salary_attachment.dart';
import '../../domain/entities/salary_attachment_query.dart';
import '../../domain/repository/payroll_repository.dart';
import '../datasources/payroll_remote_data_source.dart';

class PayrollRepositoryImp implements PayrollRepository {
  const PayrollRepositoryImp(this._dataSource);

  final PayrollRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<Payslip>>> getPayslips({
    required String token,
    required PayslipQuery query,
  }) {
    return _run(() => _dataSource.getPayslips(token: token, query: query));
  }

  @override
  Future<Either<Failure, PayslipDetail>> getPayslip({
    required String token,
    required int payslipId,
  }) {
    return _run(
      () => _dataSource.getPayslip(token: token, payslipId: payslipId),
    );
  }

  @override
  Future<Either<Failure, PayslipWorkedDays>> getPayslipWorkedDays({
    required String token,
    required int payslipId,
  }) {
    return _run(
      () =>
          _dataSource.getPayslipWorkedDays(token: token, payslipId: payslipId),
    );
  }

  @override
  Future<Either<Failure, PayslipLines>> getPayslipLines({
    required String token,
    required int payslipId,
  }) {
    return _run(
      () => _dataSource.getPayslipLines(token: token, payslipId: payslipId),
    );
  }

  @override
  Future<Either<Failure, List<int>>> getPayslipPdf({
    required String token,
    required int payslipId,
  }) {
    return _run(
      () => _dataSource.getPayslipPdf(token: token, payslipId: payslipId),
    );
  }

  @override
  Future<Either<Failure, List<SalaryAttachment>>> getSalaryAttachments({
    required String token,
    required SalaryAttachmentQuery query,
  }) {
    return _run(
      () => _dataSource.getSalaryAttachments(token: token, query: query),
    );
  }

  @override
  Future<Either<Failure, SalaryAttachment>> getSalaryAttachment({
    required String token,
    required int attachmentId,
  }) {
    return _run(
      () => _dataSource.getSalaryAttachment(
        token: token,
        attachmentId: attachmentId,
      ),
    );
  }

  /// Maps a data source call onto [Either], following the same error handling
  /// for every payroll endpoint.
  Future<Either<Failure, T>> _run<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on ServerFaliure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(ServerFaliure.fromDioError(e));
    } catch (e) {
      return Left(ServerFaliure(e.toString()));
    }
  }
}
