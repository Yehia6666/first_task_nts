import 'dart:developer';

import 'package:first_task_nts/core/constants/app_radius.dart';
import 'package:first_task_nts/core/errors/validator.dart';
import 'package:first_task_nts/core/utils/app_router.dart';
import 'package:first_task_nts/core/widgets/app_button.dart';
import 'package:first_task_nts/core/widgets/app_search_field.dart';
import 'package:first_task_nts/features/auth/presentation/cubit/server/server_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class DatabaseContainer extends StatefulWidget {
  const DatabaseContainer({super.key});

  @override
  State<DatabaseContainer> createState() => _DatabaseContainerState();
}

class _DatabaseContainerState extends State<DatabaseContainer> {
  final _formKey = GlobalKey<FormState>();
  final _databaseController = TextEditingController();

  @override
  void dispose() {
    _databaseController.dispose();
    super.dispose();
  }

  void _continue(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ServerCubit>().validateDatabase(_databaseController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServerCubit, ServerState>(
      listener: (context, state) {
        if (state is ServerSuccess) {
                    log('Success message is : ${state.validation.message}');

          context.pushReplacement(AppRouter.login);
        } else if (state is ServerFailure) {
          log('error message is : ${state.errorMessage}');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(
            // backgroundColor: Colors.white,
            content: Text(state.errorMessage,style: TextStyle(
            color: Colors.white
          ),)));
        }
      },
      child: BlocBuilder<ServerCubit, ServerState>(
        builder: (context, state) {
          final isLoading = state is ServerLoading;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 24, vertical: 44),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
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
                  'Database URL',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: AppColors.mainPrimaryColor,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Enter your server address to continue',
                  style: AppTextStyles.bodyLarge,
                ),
                SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: AppSearchField(
                    controller: _databaseController,
                    onSubmit: (value) {
                      _continue(context);
                    },
                    validator: (val) {
                      return validInput(val ?? '', 5, 2048, 'url');
                    },
                    height: 56,
                    hintText: 'Database Url',
                    prefixIcon: Icons.link,
                    radius: AppRadius.md,
                  ),
                ),
                SizedBox(height: 24),
                isLoading
                    ? CircularProgressIndicator(
                      color: AppColors.mainPrimaryColor,
                      
                    )
                    : AppButton(
                        label: 'Continue',
                        onPressed: isLoading
                            ? () {}
                            : () {
                                _continue(context);
                              },
                        icon: Icons.arrow_forward,
                        backgroundColor: AppColors.mainPrimaryColor,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
