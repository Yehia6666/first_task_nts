import 'package:first_task_nts/core/constants/app_colors.dart';
import 'package:first_task_nts/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProfileCardTitle extends StatelessWidget {
  const ProfileCardTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('ProService', style: AppTextStyles.bodyMedium),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(24 * 0.3),
          ),
          alignment: Alignment.center,
          child: Text(
            'N',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
