import 'package:flutter/material.dart';

import '../../../../core/widgets/app_segmented_tabs.dart';
import '../../domain/entities/expense_tab.dart';

/// Rounded segmented control for My Expenses / Team Expenses.
class ExpenseTabs extends StatelessWidget {
  const ExpenseTabs({
    super.key,
    required this.selectedTab,
    required this.onChanged,
  });

  final ExpenseTab selectedTab;
  final ValueChanged<ExpenseTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppSegmentedTabs(
      labels: const ['My Expenses', 'Team Expenses'],
      selectedIndex: selectedTab == ExpenseTab.my ? 0 : 1,
      onChanged: (index) => onChanged(
        index == 0 ? ExpenseTab.my : ExpenseTab.team,
      ),
    );
  }
}
