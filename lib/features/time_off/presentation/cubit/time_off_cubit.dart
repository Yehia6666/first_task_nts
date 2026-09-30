import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/time_off_request.dart';
import '../../domain/usecases/filter_time_off_requests.dart';
import '../states/time_off_state.dart';

class TimeOffCubit extends Cubit<TimeOffState> {
  TimeOffCubit({required this.filterRequests}) : super(const TimeOffInitial()) {
    _emitFiltered();
  }

  final FilterTimeOffRequests filterRequests;

  final List<TimeOffRequest> _allRequests = const [];
  String _searchQuery = '';

  void onSearchChanged(String query) {
    _searchQuery = query;
    _emitFiltered();
  }

  void _emitFiltered() {
    emit(TimeOffRequestsLoaded(
      requests: filterRequests(
        requests: _allRequests,
        query: _searchQuery,
      ),
      searchQuery: _searchQuery,
    ));
  }
}
