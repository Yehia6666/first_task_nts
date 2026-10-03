import 'package:first_task_nts/core/constants/app_colors.dart';
import 'package:first_task_nts/features/auth/presentation/widget/server_screen_body.dart';
import 'package:flutter/material.dart';

class ServerScreen extends StatelessWidget {
  const ServerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ServerScreenBody(),
    );
  }
}