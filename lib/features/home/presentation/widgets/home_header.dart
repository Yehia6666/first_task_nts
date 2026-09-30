import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/widgets/app_logo.dart';
import 'home_avatar_button.dart';
import 'home_notification_bell.dart';

/// Home header: hamburger menu (opens the drawer), app logo, notification
/// bell and a double-ring avatar button. Minimal and borderless.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.onMenuTap});

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.pagePadding(context),
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onMenuTap,
            tooltip: 'Open menu',
            icon: const Icon(
              Icons.menu_rounded,
              size: 20,
              color: AppColors.textPrimary,
            ),
          ),
          const AppLogo(),
          const Spacer(),
          const HomeNotificationBell(),
          const SizedBox(width: AppSpacing.sm),
          const HomeAvatarButton(),
        ],
      ),
    );
  }
}
