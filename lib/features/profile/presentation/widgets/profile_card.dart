import 'package:first_task_nts/core/theme/app_text_styles.dart';
import 'package:first_task_nts/features/profile/presentation/widgets/profile_card_image.dart';
import 'package:first_task_nts/features/profile/presentation/widgets/profile_card_title.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      color: Colors.grey[100],
      height: screenHeight * 0.5,
      child: Card(
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
             ProfileCardTitle(),
              SizedBox(height: 8),
            ProfileCardImage(),
              SizedBox(height: 8),
              Text(
                'Mobile App Test (copy)',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Mobile App Test (copy)', style: AppTextStyles.bodyMedium),
              Spacer(),
              Text('TAP CARD TO FLIP', style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
