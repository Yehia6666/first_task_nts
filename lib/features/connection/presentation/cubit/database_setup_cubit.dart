import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/database_url.dart';
import '../../domain/entities/validated_database.dart';
import '../../domain/usecases/get_saved_database_url.dart';
import '../../domain/usecases/save_database_url.dart';
import '../../domain/usecases/validate_database.dart';
import '../../domain/usecases/validate_database_url.dart';
import '../states/database_setup_state.dart';

class DatabaseSetupCubit extends Cubit<DatabaseSetupState> {
  DatabaseSetupCubit({
    required this.validateDatabaseUrl,
    required this.validateDatabase,
    required this.saveDatabaseUrl,
    required this.getSavedDatabaseUrl,
  }) : super(const DatabaseSetupInitial(url: '')) {
    _restoreSavedUrl();
  }

  final ValidateDatabaseUrl validateDatabaseUrl;
  final ValidateDatabase validateDatabase;
  final SaveDatabaseUrl saveDatabaseUrl;
  final GetSavedDatabaseUrl getSavedDatabaseUrl;

  Future<void> _restoreSavedUrl() async {
    final DatabaseUrl? saved = await getSavedDatabaseUrl();
    if (saved == null || isClosed || state is! DatabaseSetupInitial) return;
    emit(DatabaseSetupInitial(url: saved.toString()));
  }

  void onUrlChanged(String url) {
    if (state is DatabaseSetupValidating || state.url == url) return;
    emit(DatabaseSetupInitial(url: url));
  }

  Future<void> onContinuePressed() async {
    if (state is DatabaseSetupValidating) return;

    final String raw = state.url.trim();

    if (raw.isEmpty) {
      emit(const DatabaseSetupFailure(
        url: '',
        message: 'Please enter the server URL.',
      ));
      return;
    }

    final DatabaseUrl url;
    try {
      url = validateDatabaseUrl(raw);
    } on InvalidDatabaseUrlException catch (error) {
      emit(DatabaseSetupFailure(url: raw, message: error.message));
      return;
    }

    emit(DatabaseSetupValidating(url: raw));

    try {
      final ValidatedDatabase database = await validateDatabase(url);
      if (isClosed) return;
      await saveDatabaseUrl(url);
      if (isClosed) return;
      emit(DatabaseSetupReady(url: raw, database: database));
    } on AppFailure catch (failure) {
      if (isClosed) return;
      emit(DatabaseSetupFailure(url: raw, message: _fieldMessageOf(failure)));
    } on Object {
      if (isClosed) return;
      emit(DatabaseSetupFailure(
        url: raw,
        message: 'Something went wrong. Please try again.',
      ));
    }
  }

  String _fieldMessageOf(AppFailure failure) => switch (failure) {
        NetworkFailure() => 'No internet connection. Please try again.',
        TimeoutFailure() => 'Connection timed out. Please try again.',
        _ => failure.message,
      };
}