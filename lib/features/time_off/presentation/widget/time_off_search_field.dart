import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/widgets/app_search_field.dart';

class TimeOffSearchField extends StatelessWidget {
  const TimeOffSearchField({
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
      hintText: 'Search requests...',
      background: AppColors.surfaceVariant,
      radius: AppRadius.md,
      showShadow: false,
      onChanged: onChanged,
    );
  }
}
