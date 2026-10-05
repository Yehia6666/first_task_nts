import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/payslip.dart';
import '../../domain/entities/payslip_detail.dart';
import '../../domain/entities/payslip_lines.dart';
import '../../domain/entities/payslip_query.dart';
import '../../domain/entities/payslip_worked_days.dart';
import '../../domain/entities/salary_attachment.dart';
import '../../domain/entities/salary_attachment_query.dart';

abstract class PayrollRepository {
  Future<Either<Failure, List<Payslip>>> getPayslips({
    required String token,
    required PayslipQuery query,
  });

  Future<Either<Failure, PayslipDetail>> getPayslip({
    required String token,
    required int payslipId,
  });

  Future<Either<Failure, PayslipWorkedDays>> getPayslipWorkedDays({
    required String token,
    required int payslipId,
  });

  Future<Either<Failure, PayslipLines>> getPayslipLines({
    required String token,
    required int payslipId,
  });

  Future<Either<Failure, List<int>>> getPayslipPdf({
    required String token,
    required int payslipId,
  });

  Future<Either<Failure, List<SalaryAttachment>>> getSalaryAttachments({
    required String token,
    required SalaryAttachmentQuery query,
  });

  Future<Either<Failure, SalaryAttachment>> getSalaryAttachment({
    required String token,
    required int attachmentId,
  });
}
