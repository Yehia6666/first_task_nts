import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/navigation/app_nav_cubit.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_responsive.dart';

/// Centered title with a leading back arrow, minimal and borderless.
class AttendanceHeader extends StatelessWidget {
  const AttendanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = AppResponsive.pagePadding(context);

    void handleBack() {
      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop();
      } else {
        context.read<AppNavCubit>().goBack();
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Attendance Logs',
            style: AppTextStyles.headline,
            textAlign: TextAlign.center,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: handleBack,
              tooltip: 'Back',
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 22,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
