import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../connection/domain/entities/validated_database.dart';
import '../utils/login_form_validators.dart';
import 'auth_text_field.dart';
import 'login_error_banner.dart';
import 'login_header.dart';
import 'server_summary_row.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({
    super.key,
    required this.formKey,
    required this.database,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.obscurePassword,
    required this.canSubmit,
    required this.isSubmitting,
    required this.errorMessage,
    required this.onChanged,
    required this.onTogglePasswordVisibility,
    required this.onSubmit,
    required this.onForgotPassword,
  });

  final GlobalKey<FormState> formKey;

  final ValidatedDatabase database;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  final bool obscurePassword;

  final bool canSubmit;
  final bool isSubmitting;
  final String? errorMessage;
  final VoidCallback onChanged;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: AppRadius.card,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      showBorder: false,
      showShadow: true,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(),
            const SizedBox(height: AppSpacing.xxl),
            ServerSummaryRow(database: database),
            const SizedBox(height: AppSpacing.lg),
            AuthTextField(
              controller: emailController,
              focusNode: emailFocusNode,
              label: 'Email',
              hintText: 'you@company.com',
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: LoginFormValidators.email,
              onChanged: (_) => onChanged(),
              onSubmitted: (_) => passwordFocusNode.requestFocus(),
            ),
            const SizedBox(height: AppSpacing.lg),
            AuthTextField(
              controller: passwordController,
              focusNode: passwordFocusNode,
              label: 'Password',
              hintText: 'Your password',
              prefixIcon: Icons.lock_outline,
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                onPressed: onTogglePasswordVisibility,
                icon: Icon(
                  obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                tooltip: obscurePassword ? 'Show password' : 'Hide password',
              ),
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              validator: LoginFormValidators.password,
              onChanged: (_) => onChanged(),
              onSubmitted: (_) => onSubmit(),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: AppSpacing.xl),
              LoginErrorBanner(message: errorMessage!),
            ],
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Sign in',
              height: 56,
              borderRadius: AppRadius.lg,
              labelStyle: AppTextStyles.titleLarge.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              loading: isSubmitting,
              loadingIndicatorSize: 24,
              loadingColor: AppColors.onPrimary,
              enabled: canSubmit,
              onPressed: onSubmit,
              backgroundColor: AppColors.teal,
              pressedBackgroundColor: AppColors.tealDark,
              foregroundColor: AppColors.onPrimary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: AppButton(
                label: 'Forgot password?',
                variant: AppButtonVariant.text,
                expanded: false,
                height: 36,
                labelStyle: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
                enabled: !isSubmitting,
                onPressed: onForgotPassword,
                foregroundColor: AppColors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}