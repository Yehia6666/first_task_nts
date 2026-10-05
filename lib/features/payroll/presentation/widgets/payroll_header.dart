import 'package:flutter/widgets.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class PayrollHeader extends StatelessWidget {
  const PayrollHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PAYROLL',
          style: AppTextStyles.overline.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text('Payslips', style: AppTextStyles.titleLarge),
      ],
    );
  }
}
