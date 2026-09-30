import 'package:first_task_nts/core/constants/app_colors.dart';
import 'package:first_task_nts/core/constants/app_spacing.dart';
import 'package:first_task_nts/core/utils/app_responsive.dart';
import 'package:first_task_nts/core/widgets/app_drawer.dart';
import 'package:first_task_nts/features/payroll/presentation/widget/payroll_empty_state.dart';
import 'package:first_task_nts/features/payroll/presentation/widget/payroll_header.dart';
import 'package:first_task_nts/features/payroll/presentation/widget/payroll_tabs.dart';
import 'package:flutter/material.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: SafeArea(
        bottom: false,
        child: Builder(
          builder: (scaffoldContext) => Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: PayrollHeader(
                      onMenuTap: () =>
                          Scaffold.of(scaffoldContext).openDrawer(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.pagePadding(context),
                    ),
                    child: PayrollTabs(
                      selectedIndex: _selectedTab,
                      onChanged: (index) =>
                          setState(() => _selectedTab = index),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.pagePadding(context),
                    ),
                    child: _buildContent(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return switch (_selectedTab) {
      0 => const PayrollEmptyState(message: 'No payslips found yet.'),
      _ => const PayrollEmptyState(
          message: 'No salary attachments found.',
        ),
    };
  }
}
