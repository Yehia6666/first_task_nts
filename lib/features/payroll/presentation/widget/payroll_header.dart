import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_header.dart';

class PayrollHeader extends StatelessWidget {
  const PayrollHeader({super.key, required this.onMenuTap});

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      title: 'Payroll',
      leading: IconButton(
        onPressed: onMenuTap,
        tooltip: 'Open menu',
        icon: const Icon(
          Icons.menu_rounded,
          size: 20,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
