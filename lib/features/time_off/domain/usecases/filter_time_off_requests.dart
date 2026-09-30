import '../entities/time_off_request.dart';

class FilterTimeOffRequests {
  const FilterTimeOffRequests();

  List<TimeOffRequest> call({
    required List<TimeOffRequest> requests,
    required String query,
  }) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) {
      return List.of(requests);
    }
    return requests.where((request) {
      return request.type.toLowerCase().contains(needle) ||
          request.note.toLowerCase().contains(needle) ||
          request.duration.toLowerCase().contains(needle) ||
          request.status.name.toLowerCase().contains(needle);
    }).toList();
  }
}
