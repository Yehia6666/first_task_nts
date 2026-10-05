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
import 'package:first_task_nts/features/payroll/data/datasources/payroll_remote_data_source.dart';
import 'package:first_task_nts/features/payroll/data/datasources/payroll_remote_data_source_impl.dart';
import 'package:first_task_nts/features/payroll/data/repositories/payroll_repository_imp.dart';
import 'package:first_task_nts/features/payroll/domain/repository/payroll_repository.dart';
import 'package:first_task_nts/features/payroll/domain/usecases/get_payslip.dart';
import 'package:first_task_nts/features/payroll/domain/usecases/get_payslip_lines.dart';
import 'package:first_task_nts/features/payroll/domain/usecases/get_payslip_pdf.dart';
import 'package:first_task_nts/features/payroll/domain/usecases/get_payslip_worked_days.dart';
import 'package:first_task_nts/features/payroll/domain/usecases/get_payslips.dart';
import 'package:first_task_nts/features/payroll/domain/usecases/get_salary_attachment.dart';
import 'package:first_task_nts/features/payroll/domain/usecases/get_salary_attachments.dart';
import 'package:first_task_nts/features/payroll/presentation/cubit/payroll_cubit.dart';
import 'package:first_task_nts/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:first_task_nts/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:first_task_nts/features/profile/domain/repository/profile_repository.dart';
import 'package:first_task_nts/features/profile/domain/usecases/get_profile_use_case.dart';
import 'package:first_task_nts/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:first_task_nts/core/utils/api_service.dart';
import 'package:first_task_nts/core/utils/token_store.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;
Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<AttendanceLocalDataSource>(
    () => AttendanceLocalDataSource(),
  );
  getIt.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSource(),
  );
  getIt.registerLazySingleton<HomeLocalDataSource>(() => HomeLocalDataSource());
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImp(getIt(), getIt()),
  );

  getIt.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepoImp(getIt()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImp(getIt()));
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImp(getIt(), getIt()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImp(getIt()),
  );
  getIt.registerLazySingleton<PayrollRemoteDataSource>(
    () => PayrollRemoteDataSourceImp(getIt(), getIt()),
  );
  getIt.registerLazySingleton<PayrollRepository>(
    () => PayrollRepositoryImp(getIt()),
  );

  getIt.registerFactory<GetAttendanceLogs>(() => GetAttendanceLogs(getIt()));
  getIt.registerFactory<FilterAttendanceLogs>(() => FilterAttendanceLogs());
  getIt.registerFactory<GetExpenses>(() => GetExpenses(getIt()));
  getIt.registerFactory<FilterExpenses>(() => FilterExpenses());
  getIt.registerFactory<SummarizeExpenses>(() => SummarizeExpenses());
  getIt.registerFactory<GetTodaySessionUseCase>(
    () => GetTodaySessionUseCase(getIt()),
  );
  getIt.registerFactory<CheckInUseCase>(() => CheckInUseCase(getIt()));
  getIt.registerFactory<ValidateDatabaseUseCase>(
    () => ValidateDatabaseUseCase(getIt()),
  );
  getIt.registerFactory<SignInUseCase>(() => SignInUseCase(getIt()));
  getIt.registerFactory<GetProfileUseCase>(() => GetProfileUseCase(getIt()));
  getIt.registerFactory<GetPayslipsUseCase>(() => GetPayslipsUseCase(getIt()));
  getIt.registerFactory<GetPayslipUseCase>(() => GetPayslipUseCase(getIt()));
  getIt.registerFactory<GetPayslipWorkedDaysUseCase>(
    () => GetPayslipWorkedDaysUseCase(getIt()),
  );
  getIt.registerFactory<GetPayslipLinesUseCase>(
    () => GetPayslipLinesUseCase(getIt()),
  );
  getIt.registerFactory<GetPayslipPdfUseCase>(
    () => GetPayslipPdfUseCase(getIt()),
  );
  getIt.registerFactory<GetSalaryAttachmentsUseCase>(
    () => GetSalaryAttachmentsUseCase(getIt()),
  );
  getIt.registerFactory<GetSalaryAttachmentUseCase>(
    () => GetSalaryAttachmentUseCase(getIt()),
  );

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
    () => HomeCubit(getTodaySession: getIt(), checkIn: getIt()),
  );
  getIt.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(getProfile: getIt(), tokenStore: getIt()),
  );
  getIt.registerLazySingleton<PayrollCubit>(
    () => PayrollCubit(getPayslips: getIt(), tokenStore: getIt()),
  );
  getIt.registerLazySingleton<ServerCubit>(
    () => ServerCubit(validateDatabaseUseCase: getIt()),
  );
  getIt.registerLazySingleton<LoginCubit>(
    () => LoginCubit(signInUseCase: getIt()),
  );

  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt()));
  final preferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(preferences);
  getIt.registerLazySingleton<TokenStore>(() => TokenStore(getIt()));
}

Future<void> resetServiceLocator() async {
  await getIt.reset();
}
