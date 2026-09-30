import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A single time block in the home time summary: an overline label above a
/// bold time value.
class HomeTimeBlock extends StatelessWidget {
  const HomeTimeBlock({
    super.key,
    required this.label,
    required this.time,
    this.alignEnd = false,
  });

  final String label;
  final String time;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final crossAlignment =
        alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: crossAlignment,
      children: [
        Text(
          label,
          style: AppTextStyles.overline,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          time,
          style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
