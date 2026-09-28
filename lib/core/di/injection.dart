import 'package:first_task_nts/features/attendance/data/datasources/attendance_local_data_source.dart';
import 'package:first_task_nts/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:first_task_nts/features/attendance/domain/repository/attendance_repository.dart';
import 'package:first_task_nts/features/attendance/domain/usecases/filter_attendance_logs.dart';
import 'package:first_task_nts/features/attendance/domain/usecases/get_attendance_logs.dart';
import 'package:first_task_nts/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:first_task_nts/features/connection/data/datasources/database_validation_remote_data_source.dart';
import 'package:first_task_nts/features/connection/data/datasources/server_config_local_data_source.dart';
import 'package:first_task_nts/features/connection/data/repositories/connection_repository_impl.dart';
import 'package:first_task_nts/features/connection/domain/repository/connection_repository.dart';
import 'package:first_task_nts/features/connection/domain/usecases/get_saved_database_url.dart';
import 'package:first_task_nts/features/connection/domain/usecases/save_database_url.dart';
import 'package:first_task_nts/features/connection/domain/usecases/validate_database.dart';
import 'package:first_task_nts/features/connection/domain/usecases/validate_database_url.dart';
import 'package:first_task_nts/features/connection/presentation/cubit/database_setup_cubit.dart';
import 'package:first_task_nts/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:first_task_nts/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:first_task_nts/features/expenses/domain/repository/expense_repository.dart';
import 'package:first_task_nts/features/expenses/domain/usecases/filter_expenses.dart';
import 'package:first_task_nts/features/expenses/domain/usecases/get_expenses.dart';
import 'package:first_task_nts/features/expenses/domain/usecases/summarize_expenses.dart';
import 'package:first_task_nts/features/expenses/presentation/cubit/expenses_cubit.dart';
import 'package:first_task_nts/features/home/data/datasources/home_local_data_source.dart';
import 'package:first_task_nts/features/home/data/repositories/home_repository_impl.dart';
import 'package:first_task_nts/features/home/domain/repository/home_repository.dart';
import 'package:first_task_nts/features/home/domain/usecases/check_in.dart';
import 'package:first_task_nts/features/home/domain/usecases/get_today_session.dart';
import 'package:first_task_nts/features/home/presentation/cubit/home_cubit.dart';
import 'package:first_task_nts/features/login/data/datasources/auth_local_data_source.dart';
import 'package:first_task_nts/features/login/data/datasources/auth_remote_data_source.dart';
import 'package:first_task_nts/features/login/data/repositories/auth_repository_impl.dart';
import 'package:first_task_nts/features/login/domain/repository/auth_repository.dart';
import 'package:first_task_nts/features/login/domain/usecases/request_password_reset.dart';
import 'package:first_task_nts/features/login/domain/usecases/save_auth_token.dart';
import 'package:first_task_nts/features/login/domain/usecases/sign_in.dart';
import 'package:first_task_nts/features/login/presentation/cubit/login_cubit.dart';
import 'package:first_task_nts/features/profile/presentation/cubit/profile_cubit.dart';

class AppDependencies {
  AppDependencies({
    required this.attendanceCubit,
    required this.expensesCubit,
    required this.homeCubit,
    required this.profileCubit,
    required this.databaseSetupCubit,
    required this.loginCubit,
  });

  final AttendanceCubit attendanceCubit;
  final ExpensesCubit expensesCubit;
  final HomeCubit homeCubit;
  final ProfileCubit profileCubit;
  final DatabaseSetupCubit databaseSetupCubit;
  final LoginCubit loginCubit;
}

AppDependencies buildAppDependencies() {
  final AttendanceRepository attendanceRepository = AttendanceRepositoryImpl(
    AttendanceLocalDataSource(),
  );
  final ExpenseRepository expenseRepository = ExpenseRepositoryImpl(
    ExpenseLocalDataSource(),
  );
  final HomeRepository homeRepository = HomeRepositoryImpl(
    HomeLocalDataSource(),
  );
  final ConnectionRepository connectionRepository = ConnectionRepositoryImpl(
    DatabaseValidationRemoteDataSource(),
    ServerConfigLocalDataSource(),
  );
  final AuthRepository authRepository = AuthRepositoryImpl(
    AuthRemoteDataSource(),
    AuthLocalDataSource(),
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

  final databaseSetupCubit = DatabaseSetupCubit(
    validateDatabaseUrl: const ValidateDatabaseUrl(),
    validateDatabase: ValidateDatabase(connectionRepository),
    saveDatabaseUrl: SaveDatabaseUrl(connectionRepository),
    getSavedDatabaseUrl: GetSavedDatabaseUrl(connectionRepository),
  );

  final loginCubit = LoginCubit(
    signIn: SignIn(authRepository),
    requestPasswordReset: RequestPasswordReset(authRepository),
    saveAuthToken: SaveAuthToken(authRepository),
    getSavedDatabaseUrl: GetSavedDatabaseUrl(connectionRepository),
  );

  return AppDependencies(
    attendanceCubit: attendanceCubit,
    expensesCubit: expensesCubit,
    homeCubit: homeCubit,
    profileCubit: profileCubit,
    databaseSetupCubit: databaseSetupCubit,
    loginCubit: loginCubit,
  );
}