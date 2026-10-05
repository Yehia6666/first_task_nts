import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_state.dart';
import '../cubit/payroll_cubit.dart';
import 'payslip_card.dart';

/// Renders the payslip list for every [PayrollState] using the shared
/// loading / error / empty widgets.
class PayrollListContent extends StatelessWidget {
  const PayrollListContent({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PayrollCubit, PayrollState>(
      builder: (context, state) {
        return switch (state) {
          PayrollInitial() || PayrollLoading() => const AppLoadingState(),
          PayrollFailure(:final errorMessage) => AppErrorState(
            message: errorMessage,
            onRetry: onRetry,
          ),
          PayrollSuccess(:final payslips) when payslips.isEmpty =>
            const AppEmptyState(
              icon: Icons.account_balance_wallet_outlined,
              title: 'No payslips yet',
              message: 'Payslips issued to you will appear here.',
            ),
          PayrollSuccess(:final payslips) => ListView.separated(
            padding: EdgeInsets.fromLTRB(
              AppResponsive.pagePadding(context),
              AppSpacing.sm,
              AppResponsive.pagePadding(context),
              AppSpacing.xl,
            ),
            itemCount: payslips.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) =>
                PayslipCard(payslip: payslips[index]),
          ),
        };
      },
    );
  }
}
