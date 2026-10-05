import 'package:first_task_nts/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:first_task_nts/features/profile/presentation/widgets/contact_info.dart';
import 'package:first_task_nts/features/profile/presentation/widgets/profile_back_card.dart';
import 'package:first_task_nts/features/profile/presentation/widgets/profile_front_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Body of the profile screen: the flippable profile card plus contact info.
///
/// Receives the already-resolved [ProfileSuccess] state from `ProfileScreen`,
/// which owns the only [ProfileCubit] listener for this route. A second
/// BlocBuilder on the same cubit is therefore unnecessary: the screen rebuilds
/// this widget for every state change, including the card flip.
class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key, required this.state});

  final ProfileSuccess state;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ListView(
      children: [
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
        ContactInfo(
          email: state.email,
          phone: state.phone,
        ),
      ],
    );
  }
}
