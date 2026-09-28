import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_status_badge.dart';
import '../../domain/entities/expense.dart';

class ExpenseStatusBadge extends StatelessWidget {
  const ExpenseStatusBadge({super.key, required this.status});

  final ExpenseStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      ExpenseStatus.toReport => const AppStatusBadge(
          label: 'TO REPORT',
          background: AppColors.accentVioletContainer,
          foreground: AppColors.accentViolet,
        ),
      ExpenseStatus.pending => const AppStatusBadge(
          label: 'PENDING',
          background: AppColors.warningContainer,
          foreground: AppColors.warningDark,
        ),
      ExpenseStatus.paid => const AppStatusBadge(
          label: 'PAID',
          background: AppColors.successContainer,
          foreground: AppColors.successDark,
        ),
    };
  }
}
