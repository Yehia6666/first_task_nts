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
import 'features/home/data/datasources/home_local_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repository/home_repository.dart';
import 'features/home/domain/usecases/check_in.dart';
import 'features/home/domain/usecases/get_today_session.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';

void main() {
  final AttendanceRepository attendanceRepository = AttendanceRepositoryImpl(
    AttendanceLocalDataSource(),
  );
  final ExpenseRepository expenseRepository = ExpenseRepositoryImpl(
    ExpenseLocalDataSource(),
  );
  final HomeRepository homeRepository = HomeRepositoryImpl(
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
    getTodaySession: GetTodaySession(homeRepository),
    checkIn: CheckIn(homeRepository),
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
