import 'package:equatable/equatable.dart';

/// Query parameters accepted by the salary attachments endpoint.
///
/// [state] is one of the documented `open` / `close` / `cancel` values and
/// defaults to `open`. [limit] and [offset] keep the documented defaults of 50
/// and 0, matching the payslips endpoint.
class SalaryAttachmentQuery extends Equatable {
  const SalaryAttachmentQuery({
    this.state = defaultState,
    this.limit = defaultLimit,
    this.offset = defaultOffset,
  });

  static const String defaultState = 'open';
  static const int defaultLimit = 50;
  static const int defaultOffset = 0;

  static const List<String> states = ['open', 'close', 'cancel'];

  final String state;
  final int limit;
  final int offset;

  SalaryAttachmentQuery copyWith({String? state, int? limit, int? offset}) {
    return SalaryAttachmentQuery(
      state: state ?? this.state,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  @override
  List<Object> get props => [state, limit, offset];
}
