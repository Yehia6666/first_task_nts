import 'package:first_task_nts/app_shell.dart';
import 'package:first_task_nts/features/profile/presentation/cubit/profile_cubit.dart';
// import 'package:first_task_nts/features/profile/presentation/screen/profile_screen.dart';
// import 'package:first_task_nts/features/time_off/presentation/screen/time_off_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/navigation/app_nav_cubit.dart';
import 'core/theme/app_theme.dart';
import 'features/attendance/presentation/cubit/attendance_cubit.dart';
import 'features/expenses/presentation/cubit/expenses_cubit.dart';
import 'features/home/presentation/cubit/home_cubit.dart';

class NtsApp extends StatelessWidget {
  const NtsApp({
    super.key,
    required this.attendanceCubit,
    required this.expensesCubit,
    required this.homeCubit,
    required this.profileCubit,
  });

  final AttendanceCubit attendanceCubit;
  final ExpensesCubit expensesCubit;
  final HomeCubit homeCubit;
  final ProfileCubit profileCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: attendanceCubit),
        BlocProvider.value(value: expensesCubit),
        BlocProvider.value(value: homeCubit),
        BlocProvider.value(value: profileCubit),

        BlocProvider(create: (_) => AppNavCubit()),
      ],
      child: MaterialApp(
        title: 'NTS App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const AppShell(), 
      ),
    );
  }
}
