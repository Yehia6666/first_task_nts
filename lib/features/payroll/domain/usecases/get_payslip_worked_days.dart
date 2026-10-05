import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/payslip_worked_days.dart';
import '../repository/payroll_repository.dart';

/// Fetches the worked days and inputs of one payslip.
class GetPayslipWorkedDaysUseCase {
  const GetPayslipWorkedDaysUseCase(this._repository);

  final PayrollRepository _repository;

  Future<Either<Failure, PayslipWorkedDays>> call({
    required String token,
    required int payslipId,
  }) {
    return _repository.getPayslipWorkedDays(token: token, payslipId: payslipId);
  }
}
