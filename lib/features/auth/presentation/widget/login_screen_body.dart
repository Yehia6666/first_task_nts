import 'package:first_task_nts/core/constants/app_colors.dart';
import 'package:first_task_nts/core/theme/app_text_styles.dart';
import 'package:first_task_nts/features/auth/presentation/widget/login_container.dart';
import 'package:flutter/material.dart';

class LoginScreenBody extends StatelessWidget {
  const LoginScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 70),
        Image.asset('assets/images/home/logo.jpeg', height: 80, width: 80),
        LoginContainer(),
        InkWell(
          onTap: () {},
          child: Text(
            'Forget Password ?',
            textAlign: TextAlign.center,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.mainPrimaryColor,
            ),
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }
}
