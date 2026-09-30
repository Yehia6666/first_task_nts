import 'package:equatable/equatable.dart';

import '../../domain/entities/time_off_request.dart';

sealed class TimeOffState extends Equatable {
  const TimeOffState();

  @override
  List<Object?> get props => [];
}

class TimeOffInitial extends TimeOffState {
  const TimeOffInitial();
}

class TimeOffRequestsLoaded extends TimeOffState {
  const TimeOffRequestsLoaded({
    required this.requests,
    required this.searchQuery,
  });

  final List<TimeOffRequest> requests;
  final String searchQuery;

  @override
  List<Object?> get props => [requests, searchQuery];
}
