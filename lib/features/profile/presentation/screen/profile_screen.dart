import 'package:first_task_nts/core/shimmer/shimmer_profile.dart';
import 'package:first_task_nts/core/theme/app_text_styles.dart';
import 'package:first_task_nts/core/widgets/app_state_views.dart';
import 'package:first_task_nts/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:first_task_nts/features/profile/presentation/widgets/profile_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile", style: AppTextStyles.titleLarge),
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) => switch (state) {
          ProfileSuccess() => const ProfileScreenBody(),
          ProfileFailure(:final error) => AppErrorState(
              message: error,
              onRetry: () => context.read<ProfileCubit>().loadProfile(),
            ),
          _ => const ShimmerProfile(),
        },
      ),
    );
  }
}
