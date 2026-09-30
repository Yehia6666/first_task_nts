import 'package:flutter/material.dart';

import '../../../../core/widgets/app_segmented_tabs.dart';

class PayrollTabs extends StatelessWidget {
  const PayrollTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppSegmentedTabs(
      labels: const ['MY PAYSLIPS', 'SALARY ATTACHMENT'],
      selectedIndex: selectedIndex,
      onChanged: onChanged,
    );
  }
}
