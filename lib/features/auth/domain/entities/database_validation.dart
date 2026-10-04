import 'package:equatable/equatable.dart';

import 'database_info.dart';

class DatabaseValidation extends Equatable {
  const DatabaseValidation({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  final String status;
  final String code;
  final String message;
  final DatabaseInfo data;

  bool get isSuccess => code == 'success';

  @override
  List<Object> get props => [status, code, message, data];
}
