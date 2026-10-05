
import '../../domain/entities/payslip_query.dart';
import '../../domain/entities/salary_attachment_query.dart';
import '../models/payslip_detail_model.dart';
import '../models/payslip_lines_model.dart';
import '../models/payslip_model.dart';
import '../models/payslip_worked_days_model.dart';
import '../models/salary_attachment_model.dart';

abstract class PayrollRemoteDataSource {
  Future<List<PayslipModel>> getPayslips({
    required String token,
    required PayslipQuery query,
  });

  Future<PayslipDetailModel> getPayslip({
    required String token,
    required int payslipId,
  });

  Future<PayslipWorkedDaysModel> getPayslipWorkedDays({
    required String token,
    required int payslipId,
  });

  Future<PayslipLinesModel> getPayslipLines({
    required String token,
    required int payslipId,
  });

  Future<List<int>> getPayslipPdf({
    required String token,
    required int payslipId,
  });

  Future<List<SalaryAttachmentModel>> getSalaryAttachments({
    required String token,
    required SalaryAttachmentQuery query,
  });

  Future<SalaryAttachmentModel> getSalaryAttachment({
    required String token,
    required int attachmentId,
  });
}
