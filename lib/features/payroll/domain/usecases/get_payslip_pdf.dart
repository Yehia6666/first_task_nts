import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repository/payroll_repository.dart';

/// Downloads the PDF of one payslip as raw bytes.
class GetPayslipPdfUseCase {
  const GetPayslipPdfUseCase(this._repository);

  final PayrollRepository _repository;

  Future<Either<Failure, List<int>>> call({
    required String token,
    required int payslipId,
  }) {
    return _repository.getPayslipPdf(token: token, payslipId: payslipId);
  }
}
