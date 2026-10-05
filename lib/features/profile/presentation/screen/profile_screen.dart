import 'package:first_task_nts/core/di/injection_container.dart';
import 'package:first_task_nts/core/shimmer/shimmer_profile.dart';
import 'package:first_task_nts/core/theme/app_text_styles.dart';
import 'package:first_task_nts/core/utils/token_store.dart';
import 'package:first_task_nts/features/profile/domain/usecases/get_profile_use_case.dart';
import 'package:first_task_nts/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:first_task_nts/features/profile/presentation/widgets/profile_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit(
        getProfile: getIt<GetProfileUseCase>(),
        tokenStore: getIt<TokenStore>(),
      )..load(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Profile", style: AppTextStyles.titleLarge),
          leading: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileSuccess) {
              return ProfileScreenBody(state: state);
            } else if (state is ProfileFailure) {
              return Text(state.error);
            } else {
              return ShimmerProfile();
            }
          },
        ),
      ),
    );
  }
}
