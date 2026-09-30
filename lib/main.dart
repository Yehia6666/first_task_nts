import 'package:first_task_nts/core/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:first_task_nts/core/theme/app_theme.dart';
import 'package:first_task_nts/core/utils/app_router.dart';
import 'package:first_task_nts/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:first_task_nts/features/expenses/presentation/cubit/expenses_cubit.dart';
import 'package:first_task_nts/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:first_task_nts/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const NtsApp());
}

class NtsApp extends StatefulWidget {
  const NtsApp({super.key});

  @override
  State<NtsApp> createState() => _NtsAppState();
}

class _NtsAppState extends State<NtsApp> {
  late final AttendanceCubit _attendanceCubit;
  late final ExpensesCubit _expensesCubit;
  late final HomeCubit _homeCubit;
  late final ProfileCubit _profileCubit;

  @override
  void initState() {
    super.initState();
    _attendanceCubit = getIt<AttendanceCubit>();
    _expensesCubit = getIt<ExpensesCubit>();
    _homeCubit = getIt<HomeCubit>();
    _profileCubit = getIt<ProfileCubit>();
  }

  @override
  void dispose() {
    _attendanceCubit.close();
    _expensesCubit.close();
    _homeCubit.close();
    _profileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _attendanceCubit),
        BlocProvider.value(value: _expensesCubit),
        BlocProvider.value(value: _homeCubit),
        BlocProvider.value(value: _profileCubit),
      ],
      child: MaterialApp.router(
        title: 'NTS App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
