import 'package:equatable/equatable.dart';

import '../../domain/entities/validated_database.dart';

sealed class DatabaseSetupState extends Equatable {
  const DatabaseSetupState({required this.url});

  final String url;

  bool get canContinue => url.trim().isNotEmpty;

  @override
  List<Object?> get props => [url];
}

class DatabaseSetupInitial extends DatabaseSetupState {
  const DatabaseSetupInitial({required super.url});

  @override
  List<Object?> get props => [...super.props];
}

class DatabaseSetupValidating extends DatabaseSetupState {
  const DatabaseSetupValidating({required super.url});

  @override
  bool get canContinue => false;

  @override
  List<Object?> get props => [...super.props];
}

class DatabaseSetupReady extends DatabaseSetupState {
  const DatabaseSetupReady({required super.url, required this.database});

  @override
  bool get canContinue => false;

  final ValidatedDatabase database;

  @override
  List<Object?> get props => [...super.props, database];
}

class DatabaseSetupFailure extends DatabaseSetupState {
  const DatabaseSetupFailure({required super.url, required this.message});

  final String message;

  @override
  List<Object?> get props => [...super.props, message];
}