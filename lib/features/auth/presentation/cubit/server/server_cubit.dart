import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/database_validation.dart';
import '../../../domain/usecases/validate_database_use_case.dart';

part 'server_state.dart';

class ServerCubit extends Cubit<ServerState> {
  ServerCubit({required this.validateDatabaseUseCase})
      : super(ServerInitial());

  final ValidateDatabaseUseCase validateDatabaseUseCase;

  Future<void> validateDatabase(String databaseUrl) async {
    emit(ServerLoading());
    final result = await validateDatabaseUseCase.call(databaseUrl);
    result.fold(
      (failure) => emit(ServerFailure(failure.errorMessage)),
      (validation) {
        if (validation.isSuccess) {
          emit(ServerSuccess(validation));
        } else {
          emit(ServerFailure(validation.message));
        }
      },
    );
  }
}
