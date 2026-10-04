part of 'server_cubit.dart';

sealed class ServerState extends Equatable {
  const ServerState();

  @override
  List<Object> get props => [];
}

final class ServerInitial extends ServerState {}

final class ServerLoading extends ServerState {}

final class ServerSuccess extends ServerState {
  const ServerSuccess(this.validation);

  final DatabaseValidation validation;

  @override
  List<Object> get props => [validation];
}

final class ServerFailure extends ServerState {
  const ServerFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
