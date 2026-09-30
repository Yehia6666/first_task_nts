import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Sign in to Masary',
          textAlign: TextAlign.center,
          style: AppTextStyles.headline.copyWith(
            fontSize: 30,
            color: AppColors.teal,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Enter your credentials to continue',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLarge,
        ),
      ],
    );
  }
}