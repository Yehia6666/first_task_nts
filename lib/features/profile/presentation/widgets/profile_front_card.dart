import 'package:first_task_nts/core/constants/app_colors.dart';
import 'package:first_task_nts/core/theme/app_text_styles.dart';
import 'package:first_task_nts/core/widgets/app_logo.dart';
import 'package:first_task_nts/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';

/// Front face of the flippable profile card: company, avatar, name and
/// department.
class ProfileFrontCard extends StatelessWidget {
  const ProfileFrontCard({super.key, required this.state});

  final ProfileSuccess state;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const ValueKey('front'),
      color: const Color(0xFF17193F),
      elevation: 12,
      shadowColor: Colors.black.withValues(alpha: 0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(state.company, style: AppTextStyles.bodyMedium),
               AppLogo(
                width: 30,
                height: 30,
               ),
              ],
            ),
            const SizedBox(height: 8),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.person, color: Colors.grey[500], size: 100),
            ),
            const SizedBox(height: 8),
            Text(
              state.name,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(state.department, style: AppTextStyles.bodyMedium),
            const Spacer(),
            Text('TAP CARD TO FLIP', style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
