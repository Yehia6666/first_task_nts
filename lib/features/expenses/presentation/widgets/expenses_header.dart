import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_header.dart';

/// Expenses screen header: menu button + large navy title.
class ExpensesHeader extends StatelessWidget {
  const ExpensesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      title: 'Expenses',
      leading: IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        tooltip: 'Menu',
        icon: const Icon(
          Icons.menu_rounded,
          size: 24,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
