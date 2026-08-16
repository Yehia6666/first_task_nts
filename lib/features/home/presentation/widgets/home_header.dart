import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/widgets/app_logo.dart';

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
          _NotificationBell(),
          const SizedBox(width: AppSpacing.sm),
          _AvatarButton(),
        ],
      ),
    );
  }
}

/// Notification bell with a small error-red status dot.
class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      tooltip: 'Notifications',
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            size: 20,
            color: AppColors.textSecondary,
          ),
          Positioned(
            right: -1,
            top: -1,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular profile button with a gray double-ring style.
class _AvatarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () {},
        customBorder: const CircleBorder(),
        child: Container(
          width: 32,
          height: 32,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.textMuted, width: 1.5),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textMuted, width: 1),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.person_outline_rounded,
              size: 14,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
