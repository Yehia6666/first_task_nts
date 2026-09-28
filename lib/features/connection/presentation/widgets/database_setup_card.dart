import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';

class DatabaseSetupCard extends StatelessWidget {
  const DatabaseSetupCard({
    super.key,
    required this.controller,
    required this.isChecking,
    required this.canContinue,
    required this.onChanged,
    required this.onContinue,
    this.focusNode,
    this.fieldError,
  });

  final TextEditingController controller;
  final bool isChecking;

  final bool canContinue;
  final ValueChanged<String> onChanged;
  final VoidCallback onContinue;
  final FocusNode? focusNode;
  final String? fieldError;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: AppRadius.card,
      padding: const EdgeInsets.all(AppSpacing.xl),
      showBorder: false,
      showShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Database URL',
            textAlign: TextAlign.center,
            style: AppTextStyles.headline.copyWith(color: AppColors.teal),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Enter your server address to continue',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            controller: controller,
            focusNode: focusNode,
            hintText: 'https://your-company.odoo.com',
            prefixIcon: Icons.link_rounded,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.go,
            textCapitalization: TextCapitalization.none,
            accentColor: AppColors.teal,
            errorText: fieldError,
            enabled: !isChecking,
            onChanged: onChanged,
            onSubmitted: (_) => onContinue(),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Continue',
            trailingIcon: Icons.arrow_forward_rounded,
            loading: isChecking,
            loadingIndicatorSize: 24,
            loadingColor: AppColors.onPrimary,
            enabled: canContinue,
            onPressed: onContinue,
            backgroundColor: AppColors.teal,
            pressedBackgroundColor: AppColors.tealDark,
          ),
        ],
      ),
    );
  }
}