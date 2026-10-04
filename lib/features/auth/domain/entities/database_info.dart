import 'package:equatable/equatable.dart';

class DatabaseInfo extends Equatable {
  const DatabaseInfo({
    required this.database,
    required this.baseUrl,
    required this.odooVersion,
    required this.mobileReady,
    required this.requiredModules,
    required this.installedModules,
  });

  final String database;
  final String baseUrl;
  final String odooVersion;
  final bool mobileReady;
  final List<String> requiredModules;
  final List<String> installedModules;

  @override
  List<Object> get props => [
        database,
        baseUrl,
        odooVersion,
        mobileReady,
        requiredModules,
        installedModules,
      ];
}
