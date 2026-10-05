import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/payslip_lines.dart';
import '../repository/payroll_repository.dart';

/// Fetches the salary computation lines of one payslip.
class GetPayslipLinesUseCase {
  const GetPayslipLinesUseCase(this._repository);

  final PayrollRepository _repository;

  Future<Either<Failure, PayslipLines>> call({
    required String token,
    required int payslipId,
  }) {
    return _repository.getPayslipLines(token: token, payslipId: payslipId);
  }
}
