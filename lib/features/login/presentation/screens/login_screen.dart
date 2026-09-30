import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_shell.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/errors/app_failure.dart';
import '../cubit/login_cubit.dart';
import '../states/login_state.dart';
import '../utils/login_form_validators.dart';
import '../widgets/forgot_password_dialog.dart';
import '../widgets/login_body.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;

  /// Guards against a second navigation while the shell is on its way.
  bool _isNavigating = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    if (_isNavigating) return;
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<LoginCubit>().signInWith(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  void _onFieldChanged() {
    context.read<LoginCubit>().onFormEdited();
    setState(() {});
  }

  Future<void> _openForgotPassword() async {
    final String? email = await ForgotPasswordDialog.show(
      context,
      initialEmail: _emailController.text.trim(),
    );
    if (email == null || !mounted) return;

    await context.read<LoginCubit>().resetPassword(email);
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Replaces the whole stack with the shell, so the login form cannot be
  /// reached again with the back gesture.
  void _openAppShell(BuildContext context) {
    if (_isNavigating || !context.mounted) return;
    _isNavigating = true;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const AppShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          current is LoginSuccess ||
          current is LoginPasswordResetRequested ||
          current is LoginPasswordResetFailure ||
          current is LoginMissingDatabase,
      listener: _onStateChanged,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) => LoginBody(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              emailFocusNode: _emailFocusNode,
              passwordFocusNode: _passwordFocusNode,
              obscurePassword: _obscurePassword,
              canSubmit: _canSubmit(state),
              isSubmitting: state.isBusy,
              errorTitle: _errorTitleOf(state),
              errorMessage: _errorMessageOf(state),
              submitLabel: _submitLabelOf(state),
              onChanged: _onFieldChanged,
              onTogglePasswordVisibility: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              onSubmit: _submit,
              onForgotPassword: _openForgotPassword,
            ),
          ),
        ),
      ),
    );
  }

  void _onStateChanged(BuildContext context, LoginState state) => switch (state) {
        LoginSuccess() => _openAppShell(context),
        LoginPasswordResetRequested(message: final message) => _showMessage(message),
        LoginPasswordResetFailure(message: final message) => _showMessage(message),
        LoginMissingDatabase() => _showMessage(
            'The server address is no longer saved. Please enter it again.',
          ),
        _ => null,
      };

  bool _canSubmit(LoginState state) =>
      state.canSubmit &&
      LoginFormValidators.isComplete(
        emailAddress: _emailController.text,
        passwordValue: _passwordController.text,
      );

  String? _errorMessageOf(LoginState state) => switch (state) {
        LoginInvalidCredentials(message: final message) => message,
        LoginAccountRejected(message: final message) => message,
        LoginVerificationFailed(message: final message) => message,
        LoginFailure(message: final message) => message,
        _ => null,
      };

  /// Says which check stopped the sign-in, so the message below it makes sense
  /// on its own.
  String? _errorTitleOf(LoginState state) => switch (state) {
        LoginAccountRejected(reason: final reason) => _titleOf(reason),
        LoginVerificationFailed() => 'Could not verify your account',
        _ => null,
      };

  /// A failed check kept the token, so the button itself is the retry.
  String _submitLabelOf(LoginState state) =>
      state is LoginVerificationFailed ? 'Try again' : 'Sign in';

  static String _titleOf(AccountRejection reason) => switch (reason) {
        AccountRejection.sessionExpired => 'Your session is no longer valid',
        AccountRejection.accountDisabled => 'This account is disabled',
        AccountRejection.accountDeleted => 'This account was deleted',
        AccountRejection.profileIncomplete => 'Your profile is incomplete',
      };
}
