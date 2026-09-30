import 'package:first_task_nts/features/profile/presentation/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';

const double _headerLogoSize = 30;

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
          ClipRRect(
            borderRadius: BorderRadius.circular(_headerLogoSize * 0.2),
            child: Image.asset(
              'assets/images/logo.jpeg',
              width: _headerLogoSize,
              height: _headerLogoSize,
              fit: BoxFit.cover,
              semanticLabel: 'App logo',
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          const Spacer(),
          _NotificationBell(),
          const SizedBox(width: AppSpacing.sm),
          _AvatarButton(),
        ],
      ),
    );
  }
}

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

class _AvatarButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
          );
        },
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
