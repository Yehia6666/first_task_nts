import 'dart:developer';

import 'package:first_task_nts/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/errors/validator.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_search_field.dart';

class LoginContainer extends StatefulWidget {
  const LoginContainer({super.key});

  @override
  State<LoginContainer> createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();

  bool isObsecure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _continue(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().signIn(
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          log('success messsage is :${state.response.message}');
          context.pushReplacement(AppRouter.home);
        } else if (state is LoginFailure) {
          log('error messsage is :${state.errorMessage}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          final isLoading = state is LoginLoading;
          return Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppRadius.card,
                vertical: 44,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppRadius.lg,
                vertical: AppRadius.card,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mainPrimaryColor,
                    blurRadius: 0.1,
                    offset: Offset(0, 1),
                    spreadRadius: 0.1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sigin to Masary ',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.mainPrimaryColor,
                    ),
                  ),
                  SizedBox(height: AppRadius.lg),
                  Text(
                    'Masary workforce credentials',
                    style: AppTextStyles.bodyLarge,
                  ),
                  SizedBox(height: 24),
                  AppSearchField(
                    controller: emailController,
                    validator: (val) {
                      return validInput(val ?? '', 5, 30, 'email');
                    },
                    height: 56,
                    hintText: 'email',
                    prefixIcon: Icons.email,
                    radius: AppRadius.md,
                  ),
                  SizedBox(height: 12),
                  AppSearchField(
                    controller: passwordController,
                    validator: (val) {
                      return validInput(val ?? '', 5, 30, 'password');
                    },
                    height: 56,
                    isObsecure: isObsecure,
                    suffixIcon: IconButton(
                      onPressed: () {
                        isObsecure = !isObsecure;
                        setState(() {});
                      },
                      icon: isObsecure == true
                          ? Icon(Icons.visibility, color: AppColors.textMuted)
                          : Icon(
                              Icons.visibility_off,
                              color: AppColors.textMuted,
                            ),
                    ),
                    hintText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    radius: AppRadius.md,
                  ),
                  SizedBox(height: 24),
                  isLoading
                      ? CircularProgressIndicator(
                          color: AppColors.mainPrimaryColor,
                        )
                      : AppButton(
                          label: 'Login',
                          onPressed: () {
                            log('login button');
                            _continue(context);
                          },
                          icon: Icons.lock_outline,
                          backgroundColor: AppColors.mainPrimaryColor,
                        ),
                  SizedBox(height: AppRadius.card),
                  Text(
                    'Contact Masary admin for access .',
                    style: AppTextStyles.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
