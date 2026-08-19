import 'package:first_task_nts/core/constants/app_colors.dart';
import 'package:first_task_nts/core/theme/app_text_styles.dart';
import 'package:first_task_nts/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:first_task_nts/features/profile/presentation/widgets/contact_info.dart';
import 'package:first_task_nts/features/profile/presentation/widgets/info_iteam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) {
        if (previous is ProfileSuccess && current is ProfileSuccess) {
          return previous.isCardFlipped != current.isCardFlipped;
        }
        return false;
      },
      builder: (context, state) {
        if (state is! ProfileSuccess) return const SizedBox.shrink();

        final screenHeight = MediaQuery.of(context).size.height;

        return ListView(
          children: [
            // ── Profile Card ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              color: Colors.grey[100],
              height: screenHeight * 0.5,
              child: GestureDetector(
                onTap: () => context.read<ProfileCubit>().toggleCardFlip(),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: state.isCardFlipped
                      ? _buildBackCard(state)
                      : _buildFrontCard(state),
                ),
              ),
            ),

            // ── Contact Information ──
            ContactInfo(
              email: state.email,
              phone: state.phone,
            ),
          ],
        );
      },
    );
  }

  Widget _buildFrontCard(ProfileSuccess state) {
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
            // ── Title Row ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(state.company, style: AppTextStyles.bodyMedium),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(24 * 0.3),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'N',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── Avatar ──
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.person, color: Colors.grey[500], size: 100),
            ),
            const SizedBox(height: 8),

            // ── Name & Department ──
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

  Widget _buildBackCard(ProfileSuccess state) {
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
