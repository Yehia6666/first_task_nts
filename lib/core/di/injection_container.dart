import 'package:first_task_nts/features/attendance/data/datasources/attendance_local_data_source.dart';
import 'package:first_task_nts/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:first_task_nts/features/attendance/domain/repository/attendance_repository.dart';
import 'package:first_task_nts/features/attendance/domain/usecases/filter_attendance_logs.dart';
import 'package:first_task_nts/features/attendance/domain/usecases/get_attendance_logs.dart';
import 'package:first_task_nts/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:first_task_nts/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:first_task_nts/features/auth/data/repositories_imp/auth_imp.dart';
import 'package:first_task_nts/features/auth/domain/usecases/auth_repository.dart';
import 'package:first_task_nts/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:first_task_nts/features/auth/domain/usecases/validate_database_use_case.dart';
import 'package:first_task_nts/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:first_task_nts/features/auth/presentation/cubit/server/server_cubit.dart';
import 'package:first_task_nts/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:first_task_nts/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:first_task_nts/features/expenses/domain/repository/expense_repository.dart';
import 'package:first_task_nts/features/expenses/domain/usecases/filter_expenses.dart';
import 'package:first_task_nts/features/expenses/domain/usecases/get_expenses.dart';
import 'package:first_task_nts/features/expenses/domain/usecases/summarize_expenses.dart';
import 'package:first_task_nts/features/expenses/presentation/cubit/expenses_cubit.dart';
import 'package:first_task_nts/features/home/data/data_source/home_local_data_source.dart';
import 'package:first_task_nts/features/home/data/repo/home_repo_imp.dart';
import 'package:first_task_nts/features/home/domain/repos/home_repo.dart';
import 'package:first_task_nts/features/home/domain/use_cases/check_in_use_case.dart';
import 'package:first_task_nts/features/home/domain/use_cases/get_today_session_use_case.dart';
import 'package:first_task_nts/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:first_task_nts/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:first_task_nts/core/utils/api_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

/// Global service locator for the app.
final GetIt getIt = GetIt.instance;

/// Registers all data sources, repositories, use cases and cubits.
///
/// Lifetimes:
/// - Data sources and repositories: lazy singletons (stateless, one instance
///   for the app lifetime).
/// - Use cases: factories (stateless, cheap to create).
/// - Cubits: lazy singletons (stateful, one instance shared across the app).
Future<void> setupServiceLocator() async {
  // ── Data sources ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AttendanceLocalDataSource>(
    () => AttendanceLocalDataSource(),
  );
  getIt.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSource(),
  );
  getIt.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSource(),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImp(getIt()),
  );

  // ── Repositories ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImp(getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImp(getIt()),
  );

  // ── Use cases ─────────────────────────────────────────────────────────────
  getIt.registerFactory<GetAttendanceLogs>(
    () => GetAttendanceLogs(getIt()),
  );
  getIt.registerFactory<FilterAttendanceLogs>(
    () => FilterAttendanceLogs(),
  );
  getIt.registerFactory<GetExpenses>(
    () => GetExpenses(getIt()),
  );
  getIt.registerFactory<FilterExpenses>(
    () => FilterExpenses(),
  );
  getIt.registerFactory<SummarizeExpenses>(
    () => SummarizeExpenses(),
  );
  getIt.registerFactory<GetTodaySessionUseCase>(
    () => GetTodaySessionUseCase(getIt()),
  );
  getIt.registerFactory<CheckInUseCase>(
    () => CheckInUseCase(getIt()),
  );
  getIt.registerFactory<ValidateDatabaseUseCase>(
    () => ValidateDatabaseUseCase(getIt()),
  );
  getIt.registerFactory<SignInUseCase>(
    () => SignInUseCase(getIt()),
  );

  // ── Cubits ────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AttendanceCubit>(
    () => AttendanceCubit(
      getAttendanceLogs: getIt(),
      filterAttendanceLogs: getIt(),
    ),
  );
  getIt.registerLazySingleton<ExpensesCubit>(
    () => ExpensesCubit(
      getExpenses: getIt(),
      filterExpenses: getIt(),
      summarizeExpenses: getIt(),
    ),
  );
  getIt.registerLazySingleton<HomeCubit>(
    () => HomeCubit(
      getTodaySession: getIt(),
      checkIn: getIt(),
    ),
  );
  getIt.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(),
  );
  getIt.registerLazySingleton<ServerCubit>(
    () => ServerCubit(validateDatabaseUseCase: getIt()),
  );
  getIt.registerLazySingleton<LoginCubit>(
    () => LoginCubit(signInUseCase: getIt()),
  );

  // ── Core ──────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(getIt()),
  );
}

/// Resets the service locator. Useful in tests to re-register fresh
/// instances or swap in mocks.
Future<void> resetServiceLocator() async {
  await getIt.reset();
}
