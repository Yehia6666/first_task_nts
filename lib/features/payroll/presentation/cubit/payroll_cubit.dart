import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/token_store.dart';
import '../../domain/entities/payslip.dart';
import '../../domain/entities/payslip_query.dart';
import '../../domain/usecases/get_payslips.dart';

part 'payroll_state.dart';

/// Loads payslips through [GetPayslipsUseCase] and emits the states the UI
/// renders. Contains no layout/widget code.
class PayrollCubit extends Cubit<PayrollState> {
  PayrollCubit({required this.getPayslips, required this.tokenStore})
    : super(const PayrollInitial());

  final GetPayslipsUseCase getPayslips;
  final TokenStore tokenStore;

  PayslipQuery _query = const PayslipQuery();

  /// Reads the persisted bearer token and loads payslips. When no token is
  /// stored the request is skipped and a failure is emitted instead of calling
  /// the API unauthenticated.
  Future<void> load() async {
    emit(const PayrollLoading());

    final token = await tokenStore.read();
    if (token == null || token.isEmpty) {
      emit(const PayrollFailure('No active session. Please sign in again.'));
      return;
    }

    final result = await getPayslips(token: token, query: _query);
    result.fold(
      (failure) => emit(PayrollFailure(failure.errorMessage)),
      (payslips) => emit(PayrollSuccess(payslips: payslips, query: _query)),
    );
  }

  /// Applies the documented `date_from_min` / `date_from_max` bounds (format
  /// `YYYY-MM-DD`) and resets paging. [null] clears that bound.
  void applyDateFilter({String? dateFromMin, String? dateFromMax}) {
    _query = _query.copyWith(
      dateFromMin: dateFromMin,
      dateFromMax: dateFromMax,
      offset: PayslipQuery.defaultOffset,
    );
  }
}
