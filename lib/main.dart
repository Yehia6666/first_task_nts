import 'package:flutter/material.dart';

import 'app.dart';
import 'features/attendance/data/datasources/attendance_local_data_source.dart';
import 'features/attendance/data/repositories/attendance_repository_impl.dart';
import 'features/attendance/domain/repository/attendance_repository.dart';
import 'features/attendance/domain/usecases/filter_attendance_logs.dart';
import 'features/attendance/domain/usecases/get_attendance_logs.dart';
import 'features/attendance/presentation/cubit/attendance_cubit.dart';
import 'features/expenses/data/datasources/expense_local_data_source.dart';
import 'features/expenses/data/repositories/expense_repository_impl.dart';
import 'features/expenses/domain/repository/expense_repository.dart';
import 'features/expenses/domain/usecases/filter_expenses.dart';
import 'features/expenses/domain/usecases/get_expenses.dart';
import 'features/expenses/domain/usecases/summarize_expenses.dart';
import 'features/expenses/presentation/cubit/expenses_cubit.dart';
import 'features/home/data/data_source/home_local_data_source.dart';
import 'features/home/data/repo/home_repo_imp.dart';
import 'features/home/domain/repos/home_repo.dart';
import 'features/home/domain/use_cases/check_in_use_case.dart';
import 'features/home/domain/use_cases/get_today_session_use_case.dart';
import 'features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';

void main() {
  final AttendanceRepository attendanceRepository = AttendanceRepositoryImpl(
    AttendanceLocalDataSource(),
  );
  final ExpenseRepository expenseRepository = ExpenseRepositoryImpl(
    ExpenseLocalDataSource(),
  );
  final HomeRepo homeRepo = HomeRepoImp(
    HomeLocalDataSource(),
  );

  final attendanceCubit = AttendanceCubit(
    getAttendanceLogs: GetAttendanceLogs(attendanceRepository),
    filterAttendanceLogs: const FilterAttendanceLogs(),
  );

  final expensesCubit = ExpensesCubit(
    getExpenses: GetExpenses(expenseRepository),
    filterExpenses: const FilterExpenses(),
    summarizeExpenses: const SummarizeExpenses(),
  );

  final homeCubit = HomeCubit(
    getTodaySession: GetTodaySessionUseCase(homeRepo),
    checkIn: CheckInUseCase(homeRepo),
  );

  final profileCubit = ProfileCubit();

  runApp(
    NtsApp(
      attendanceCubit: attendanceCubit,
      expensesCubit: expensesCubit,
      homeCubit: homeCubit,
      profileCubit: profileCubit,
    ),
  );
}
