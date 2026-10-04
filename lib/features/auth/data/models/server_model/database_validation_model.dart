import '../../../domain/entities/database_validation.dart';
import 'database_info_model.dart';

class DatabaseValidationModel extends DatabaseValidation {
  const DatabaseValidationModel({
    required super.status,
    required super.code,
    required super.message,
    required super.data,
  });

  factory DatabaseValidationModel.fromJson(Map<String, dynamic> json) {
    return DatabaseValidationModel(
      status: json['status']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: DatabaseInfoModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}
