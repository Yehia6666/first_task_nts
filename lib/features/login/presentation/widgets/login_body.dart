import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../connection/domain/entities/validated_database.dart';
import 'login_card.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({
    super.key,
    required this.database,
    required this.formKey,
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

  final ValidatedDatabase database;
  final GlobalKey<FormState> formKey;
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
              Center(child: AppLogoImage(size: _logoSize(context))),
              const SizedBox(height: AppSpacing.xxl),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxCardWidth),
                  child: LoginCard(
                    formKey: formKey,
                    database: database,
                    emailController: emailController,
                    passwordController: passwordController,
                    emailFocusNode: emailFocusNode,
                    passwordFocusNode: passwordFocusNode,
                    obscurePassword: obscurePassword,
                    canSubmit: canSubmit,
                    isSubmitting: isSubmitting,
                    errorMessage: errorMessage,
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