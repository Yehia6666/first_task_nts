import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_responsive.dart';
import '../states/attendance_state.dart';
import 'attendance_card.dart';

/// A titled day group ("Today", "Yesterday", ...) rendered as a column of cards.
class AttendanceSection extends StatelessWidget {
  const AttendanceSection({super.key, required this.section});

  final AttendanceDaySection section;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = AppResponsive.pagePadding(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(section.title, style: AppTextStyles.titleLarge),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final log in section.logs)
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              0,
              horizontalPadding,
              AppSpacing.md,
            ),
            child: AttendanceCard(log: log),
          ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
