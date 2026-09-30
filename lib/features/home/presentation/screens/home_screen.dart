import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../attendance/presentation/screens/attendance_logs_screen.dart';
import '../../domain/entities/attendance_session.dart';
import '../cubit/home_cubit.dart';
import '../states/home_state.dart';
import '../widgets/home_check_in_button.dart';
import '../widgets/home_check_in_header.dart';
import '../widgets/home_elapsed_progress_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/home_session_card.dart';
import '../widgets/home_time_summary.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openAttendanceLogs(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const AttendanceLogsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: SafeArea(
        bottom: false,
        // Builder so Scaffold.of() resolves to this screen's own Scaffold.
        child: Builder(
          builder: (scaffoldContext) => BlocListener<HomeCubit, HomeState>(
            listenWhen: (previous, current) =>
                current is HomeLoaded && current.feedback != null,
            listener: (context, state) {
              if (state is HomeLoaded && state.feedback != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.feedback!)),
                );
              }
            },
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: HomeHeader(
                        onMenuTap: () =>
                            Scaffold.of(scaffoldContext).openDrawer(),
                      ),
                    ),
                    Expanded(child: _buildContent(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return switch (state) {
          HomeInitial() || HomeLoading() => const AppLoadingState(
              message: 'Loading your session…',
            ),
          HomeError() => AppErrorState(
              message: state.message,
              onRetry: () => context.read<HomeCubit>().load(),
            ),
          HomeLoaded() => ListView(
              padding: EdgeInsets.fromLTRB(
                AppResponsive.pagePadding(context),
                AppSpacing.xl,
                AppResponsive.pagePadding(context),
                AppSpacing.xxl,
              ),
              children: [
                HomeCheckInHeader(
                  status: state.session.status,
                  currentTime: state.currentTime,
                ),
                const SizedBox(height: AppSpacing.xxl),
                HomeTimeSummary(session: state.session, progress: state.progress),
                const SizedBox(height: AppSpacing.lg),
                HomeElapsedProgressBar(progress: state.progress),
                const SizedBox(height: AppSpacing.xxl),
                HomeCheckInButton(
                  isLoading: state.isCheckingIn,
                  isCheckedIn:
                      state.session.status != AttendanceSessionStatus.notCheckedIn,
                  onPressed: () => context.read<HomeCubit>().onCheckInPressed(),
                ),
                const SizedBox(height: AppSpacing.xxl),
                HomeSessionCard(
                  session: state.session,
                  onLogHistory: () => _openAttendanceLogs(context),
                ),
              ],
            ),
        };
      },
    );
  }
}
