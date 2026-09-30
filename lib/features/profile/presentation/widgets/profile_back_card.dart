import 'package:first_task_nts/core/theme/app_text_styles.dart';
import 'package:first_task_nts/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:first_task_nts/features/profile/presentation/widgets/info_iteam.dart';
import 'package:flutter/material.dart';

/// Back face of the flippable profile card: employee details (department,
/// employee id, company).
class ProfileBackCard extends StatelessWidget {
  const ProfileBackCard({super.key, required this.state});

  final ProfileSuccess state;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const ValueKey('back'),
      color: const Color(0xFF17193F),
      elevation: 12,
      shadowColor: Colors.black.withValues(alpha: 0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Employee Details',
              style: AppTextStyles.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            InfoIteam(
              titel: 'DEPARTMENT',
              data: state.department,
            ),
            InfoIteam(
              titel: 'EMPLOYEE ID',
              data: state.employeeId,
            ),
            InfoIteam(
              titel: 'COMPANY',
              data: state.company,
            ),
            const Spacer(),
            Text('TAP CARD TO FLIP', style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
