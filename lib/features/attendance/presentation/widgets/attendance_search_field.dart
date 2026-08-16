import 'package:flutter/material.dart';

import '../../../../core/widgets/app_search_field.dart';

/// Attendance search field — reuses the corrected [AppSearchField] defaults so
/// it matches the Expense reference: white fill, large rounded corners, ~48px
/// height, subtle shadow, no visible border.
class AttendanceSearchField extends StatelessWidget {
  const AttendanceSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppSearchField(
      controller: controller,
      hintText: 'Search for attendance history',
      onChanged: onChanged,
    );
  }
}
