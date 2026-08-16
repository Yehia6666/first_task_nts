import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/expense.dart';

/// Small rounded square containing a category icon.
class ExpenseIcon extends StatelessWidget {
  const ExpenseIcon({super.key, required this.category});

  final ExpenseCategory category;

  IconData get _icon => switch (category) {
        ExpenseCategory.meals => Icons.restaurant_rounded,
        ExpenseCategory.mileage => Icons.directions_car_rounded,
        ExpenseCategory.travel => Icons.flight_rounded,
        ExpenseCategory.other => Icons.receipt_long_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.expenseIconSize,
      height: AppSizes.expenseIconSize,
      decoration: BoxDecoration(
        color: AppColors.accentVioletContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(_icon, size: 20, color: AppColors.accentViolet),
    );
  }
}
