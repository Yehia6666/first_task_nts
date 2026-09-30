import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import 'login_card.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.obscurePassword,
    required this.canSubmit,
    required this.isSubmitting,
    required this.errorMessage,
    required this.errorTitle,
    required this.submitLabel,
    required this.onChanged,
    required this.onTogglePasswordVisibility,
    required this.onSubmit,
    required this.onForgotPassword,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final bool obscurePassword;
  final bool canSubmit;
  final bool isSubmitting;
  final String? errorMessage;
  final String? errorTitle;
  final String submitLabel;
  final VoidCallback onChanged;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;

  static const double _maxCardWidth = 420;
  static const double _wideLogoSize = 150;

  @override
  Widget build(BuildContext context) {
    final verticalPadding = AppSpacing.xxl;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: verticalPadding,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight - verticalPadding * 2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(AppRadius.lg),
                  ),
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    width: _logoSize(context),
                    height: _logoSize(context),
                    fit: BoxFit.cover,
                    semanticLabel: 'App logo',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxCardWidth),
                  child: LoginCard(
                    formKey: formKey,
                    emailController: emailController,
                    passwordController: passwordController,
                    emailFocusNode: emailFocusNode,
                    passwordFocusNode: passwordFocusNode,
                    obscurePassword: obscurePassword,
                    canSubmit: canSubmit,
                    isSubmitting: isSubmitting,
                    errorMessage: errorMessage,
                    errorTitle: errorTitle,
                    submitLabel: submitLabel,
                    onChanged: onChanged,
                    onTogglePasswordVisibility: onTogglePasswordVisibility,
                    onSubmit: onSubmit,
                    onForgotPassword: onForgotPassword,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _logoSize(BuildContext context) =>
      AppResponsive.isMobile(context) ? AppSizes.authLogoSize : _wideLogoSize;
}