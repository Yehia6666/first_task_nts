import '../../../domain/entities/database_info.dart';

class DatabaseInfoModel extends DatabaseInfo {
  const DatabaseInfoModel({
    required super.database,
    required super.baseUrl,
    required super.odooVersion,
    required super.mobileReady,
    required super.requiredModules,
    required super.installedModules,
  });

  factory DatabaseInfoModel.fromJson(Map<String, dynamic> json) {
    return DatabaseInfoModel(
      database: json['database']?.toString() ?? '',
      baseUrl: json['base_url']?.toString() ?? '',
      odooVersion: json['odoo_version']?.toString() ?? '',
      mobileReady: json['mobile_ready'] == true,
      requiredModules: (json['required_modules'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      installedModules: (json['installed_modules'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
