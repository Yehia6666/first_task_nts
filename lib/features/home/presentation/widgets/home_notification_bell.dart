import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Notification bell with a small error-red status dot.
class HomeNotificationBell extends StatelessWidget {
  const HomeNotificationBell({super.key});

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
