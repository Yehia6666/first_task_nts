import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/payslip_detail.dart';
import '../repository/payroll_repository.dart';

/// Fetches one payslip through the repository abstraction.
class GetPayslipUseCase {
  const GetPayslipUseCase(this._repository);

  final PayrollRepository _repository;

  Future<Either<Failure, PayslipDetail>> call({
    required String token,
    required int payslipId,
  }) {
    return _repository.getPayslip(token: token, payslipId: payslipId);
  }
}
