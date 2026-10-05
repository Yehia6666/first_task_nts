part of 'payroll_cubit.dart';

sealed class PayrollState extends Equatable {
  const PayrollState();

  @override
  List<Object> get props => [];
}

final class PayrollInitial extends PayrollState {
  const PayrollInitial();
}

final class PayrollLoading extends PayrollState {
  const PayrollLoading();
}

final class PayrollSuccess extends PayrollState {
  const PayrollSuccess({required this.payslips, required this.query});

  final List<Payslip> payslips;
  final PayslipQuery query;

  @override
  List<Object> get props => [payslips, query];
}

final class PayrollFailure extends PayrollState {
  const PayrollFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
