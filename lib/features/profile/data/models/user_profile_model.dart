import '../../domain/entities/user_profile.dart';

class EmployeeModel extends EmployeeProfile {
  const EmployeeModel({
    super.id,
    super.code,
    super.name,
    super.imageUrl,
    super.gender,
    super.birthday,
    super.jobTitle,
    super.department,
    super.division,
    super.company,
    super.jobPosition,
    super.reference,
    super.workEmail,
    super.workPhone,
    super.workMobile,
  });

  static EmployeeModel? fromJson(Object? json) {
    if (json is! Map<String, dynamic>) return null;
    return EmployeeModel(
      id: JsonValues.intOf(json, const <String>['employee_id', 'id']),
      code: JsonValues.stringOf(json, const <String>['employee_code', 'code']),
      name: JsonValues.stringOf(
        json,
        const <String>['employee_name', 'name'],
      ),
      imageUrl: JsonValues.stringOf(
        json,
        const <String>['employee_image', 'image', 'avatar', 'image_url'],
      ),
      gender: JsonValues.stringOf(
        json,
        const <String>['employee_gender', 'gender'],
      ),
      birthday: JsonValues.stringOf(
        json,
        const <String>['employee_birthday', 'birthday', 'birth_date'],
      ),
      jobTitle: JsonValues.stringOf(
        json,
        const <String>['job_title', 'jobTitle'],
      ),
      department: JsonValues.stringOf(
        json,
        const <String>['department'],
      ),
      division: JsonValues.stringOf(json, const <String>['division']),
      company: JsonValues.stringOf(json, const <String>['company']),
      jobPosition: JsonValues.stringOf(
        json,
        const <String>['job_position', 'jobPosition'],
      ),
      reference: JsonValues.stringOf(json, const <String>['reference']),
      workEmail: JsonValues.stringOf(
        json,
        const <String>['work_email', 'workEmail'],
      ),
      workPhone: JsonValues.stringOf(
        json,
        const <String>['work_phone', 'workPhone'],
      ),
      workMobile: JsonValues.stringOf(
        json,
        const <String>['work_mobile', 'workMobile'],
      ),
    );
  }
}

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    super.id,
    required super.name,
    required super.email,
    super.phone,
    super.isActive,
    super.isEmailVerified,
    super.devicePlatform,
    super.appVersion,
    super.employee,
  });

  static UserProfileModel? fromJson(Map<String, dynamic> json) {
    final String? name = JsonValues.stringOf(
      json,
      const <String>['name', 'user_name', 'full_name', 'display_name'],
    );
    final String? email = JsonValues.stringOf(
      json,
      const <String>['email', 'mail', 'email_address'],
    );
    if (name == null && email == null) return null;

    return UserProfileModel(
      id: JsonValues.intOf(json, const <String>['user_id', 'id']),
      name: name ?? '',
      email: email ?? '',
      phone: JsonValues.stringOf(
        json,
        const <String>['phone', 'mobile', 'phone_number'],
      ),
      isActive: JsonValues.boolOf(
            json,
            const <String>['is_active', 'active', 'enabled'],
          ) ??
          true,
      isEmailVerified: JsonValues.boolOf(
        json,
        const <String>['email_verified', 'is_email_verified', 'verified'],
      ),
      devicePlatform: JsonValues.stringOf(
        json,
        const <String>['device_platform', 'devicePlatform'],
      ),
      appVersion: JsonValues.stringOf(
        json,
        const <String>['app_version', 'appVersion'],
      ),
      employee: EmployeeModel.fromJson(json['employee']),
    );
  }

  UserProfileModel withEmployee(EmployeeProfile? value) =>
      UserProfileModel(
        id: id,
        name: name,
        email: email,
        phone: phone,
        isActive: isActive,
        isEmailVerified: isEmailVerified,
        devicePlatform: devicePlatform,
        appVersion: appVersion,
        employee: value,
      );
}

abstract final class JsonValues {
  static String? stringOf(Map<String, dynamic> json, List<String> keys) {
    for (final String key in keys) {
      final Object? value = json[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
      if (value is num) return value.toString();
    }
    return null;
  }

  static int? intOf(Map<String, dynamic> json, List<String> keys) {
    for (final String key in keys) {
      final Object? value = json[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value.trim());
    }
    return null;
  }

  static bool? boolOf(Map<String, dynamic> json, List<String> keys) {
    for (final String key in keys) {
      final Object? value = json[key];
      if (value is bool) return value;
      if (value is num) return value != 0;
      if (value is String) {
        final String text = value.trim().toLowerCase();
        if (text == 'true' || text == '1') return true;
        if (text == 'false' || text == '0') return false;
      }
    }
    return null;
  }
}
