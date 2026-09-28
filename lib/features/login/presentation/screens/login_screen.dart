import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_shell.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../connection/domain/entities/validated_database.dart';
import '../cubit/login_cubit.dart';
import '../states/login_state.dart';
import '../utils/login_form_validators.dart';
import '../widgets/forgot_password_dialog.dart';
import '../widgets/login_body.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.database});

  final ValidatedDatabase database;

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
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
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openAppShell(BuildContext context) {
    if (!context.mounted) return;
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
              database: widget.database,
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              emailFocusNode: _emailFocusNode,
              passwordFocusNode: _passwordFocusNode,
              obscurePassword: _obscurePassword,
              canSubmit: _canSubmit(state),
              isSubmitting: state is LoginSubmitting,
              errorMessage: _errorMessageOf(state),
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
        LoginFailure(message: final message) => message,
        _ => null,
      };
}