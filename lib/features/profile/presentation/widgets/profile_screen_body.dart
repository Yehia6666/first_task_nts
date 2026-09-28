import 'package:first_task_nts/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:first_task_nts/features/profile/presentation/widgets/contact_info.dart';
import 'package:first_task_nts/features/profile/presentation/widgets/profile_back_card.dart';
import 'package:first_task_nts/features/profile/presentation/widgets/profile_front_card.dart';
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
                      ? ProfileBackCard(state: state)
                      : ProfileFrontCard(state: state),
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
}