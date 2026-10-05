import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/salary_attachment.dart';
import '../repository/payroll_repository.dart';

/// Fetches one salary attachment through the repository abstraction.
class GetSalaryAttachmentUseCase {
  const GetSalaryAttachmentUseCase(this._repository);

  final PayrollRepository _repository;

  Future<Either<Failure, SalaryAttachment>> call({
    required String token,
    required int attachmentId,
  }) {
    return _repository.getSalaryAttachment(
      token: token,
      attachmentId: attachmentId,
    );
  }
}
