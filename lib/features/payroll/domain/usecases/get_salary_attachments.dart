import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/salary_attachment.dart';
import '../entities/salary_attachment_query.dart';
import '../repository/payroll_repository.dart';

/// Fetches salary attachments through the repository abstraction.
class GetSalaryAttachmentsUseCase {
  const GetSalaryAttachmentsUseCase(this._repository);

  final PayrollRepository _repository;

  Future<Either<Failure, List<SalaryAttachment>>> call({
    required String token,
    SalaryAttachmentQuery query = const SalaryAttachmentQuery(),
  }) {
    return _repository.getSalaryAttachments(token: token, query: query);
  }
}
