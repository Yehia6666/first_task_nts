import 'package:equatable/equatable.dart';

import 'database_url.dart';

class ValidatedDatabase extends Equatable {
  const ValidatedDatabase({
    required this.database,
    required this.baseUrl,
    this.statusMessage,
  });

  final String database;

  final DatabaseUrl baseUrl;

  final String? statusMessage;

  @override
  List<Object?> get props => [database, baseUrl, statusMessage];
}
