import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/payslip.dart';
import '../entities/payslip_query.dart';
import '../repository/payroll_repository.dart';

/// Fetches payslips through the repository abstraction.
class GetPayslipsUseCase {
  const GetPayslipsUseCase(this._repository);

  final PayrollRepository _repository;

  Future<Either<Failure, List<Payslip>>> call({
    required String token,
    PayslipQuery query = const PayslipQuery(),
  }) {
    return _repository.getPayslips(token: token, query: query);
  }
}
