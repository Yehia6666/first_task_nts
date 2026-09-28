import 'package:first_task_nts/features/connection/presentation/cubit/database_setup_cubit.dart';
import 'package:first_task_nts/features/connection/presentation/screens/database_url_setup_screen.dart';
import 'package:first_task_nts/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/navigation/app_nav_cubit.dart';
import '../core/theme/app_theme.dart';
import '../features/attendance/presentation/cubit/attendance_cubit.dart';
import '../features/expenses/presentation/cubit/expenses_cubit.dart';
import '../features/home/presentation/cubit/home_cubit.dart';
import '../features/login/presentation/cubit/login_cubit.dart';

class MasaryApp extends StatelessWidget {
  const MasaryApp({
    super.key,
    required this.attendanceCubit,
    required this.expensesCubit,
    required this.homeCubit,
    required this.profileCubit,
    required this.databaseSetupCubit,
    required this.loginCubit,
    this.home = const DatabaseUrlSetupScreen(),
  });

  final AttendanceCubit attendanceCubit;
  final ExpensesCubit expensesCubit;
  final HomeCubit homeCubit;
  final ProfileCubit profileCubit;
  final DatabaseSetupCubit databaseSetupCubit;
  final LoginCubit loginCubit;

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: attendanceCubit),
        BlocProvider.value(value: expensesCubit),
        BlocProvider.value(value: homeCubit),
        BlocProvider.value(value: profileCubit),
        BlocProvider.value(value: databaseSetupCubit),
        BlocProvider.value(value: loginCubit),

        BlocProvider(create: (_) => AppNavCubit()),
      ],
      child: MaterialApp(
        title: 'Masary App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: home,
      ),
    );
  }
}