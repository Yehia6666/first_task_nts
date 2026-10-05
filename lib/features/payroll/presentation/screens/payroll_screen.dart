import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/utils/token_store.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_nav_scope.dart';
import '../../domain/usecases/get_payslips.dart';
import '../cubit/payroll_cubit.dart';
import '../widgets/payroll_header.dart';
import '../widgets/payroll_list_content.dart';

/// Payroll screen: header plus the payslip list, driven by [PayrollCubit].
class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PayrollCubit>(
      create: (context) => PayrollCubit(
        getPayslips: getIt<GetPayslipsUseCase>(),
        tokenStore: getIt<TokenStore>(),
      ),
      child: _LoadOnBranchActive(
        child: Scaffold(
          backgroundColor: AppColors.background,
          drawer: const AppDrawer(),
          body: SafeArea(
            top: true,
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.pagePadding(context),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(
                          top: AppSpacing.lg,
                          bottom: AppSpacing.md,
                        ),
                        child: PayrollHeader(),
                      ),
                    ),
                    Expanded(
                      child: PayrollListContent(
                        onRetry: () => context.read<PayrollCubit>().load(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Loads payslips whenever the Payroll branch becomes the active one.
///
/// The shell keeps every branch alive in an [IndexedStack], so this screen is
/// built once and stays mounted when the user moves away. Both the bottom
/// navigation bar and the drawer switch branches through
/// `StatefulNavigationShell.goBranch`, which changes `currentIndex` and
/// notifies [AppNavScope] dependents — so depending on the scope is what makes
/// the cubit load again on every visit, whichever way the user navigated here.
class _LoadOnBranchActive extends StatefulWidget {
  const _LoadOnBranchActive({required this.child});

  final Widget child;

  @override
  State<_LoadOnBranchActive> createState() => _LoadOnBranchActiveState();
}

class _LoadOnBranchActiveState extends State<_LoadOnBranchActive> {
  /// Branch index of Payroll, following the order declared in `AppRouter`.
  static const int _payrollBranch = 2;

  /// The branch that was active the last time this screen was notified.
  int? _activeBranch;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final branch = AppNavScope.of(context).navigationShell.currentIndex;
    if (branch == _activeBranch) return;
    _activeBranch = branch;

    if (branch == _payrollBranch) {
      context.read<PayrollCubit>().load();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
