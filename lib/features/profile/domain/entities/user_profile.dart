import 'package:equatable/equatable.dart';

class EmployeeProfile extends Equatable {
  const EmployeeProfile({
    this.id,
    this.code,
    this.name,
    this.imageUrl,
    this.gender,
    this.birthday,
    this.jobTitle,
    this.department,
    this.division,
    this.company,
    this.jobPosition,
    this.reference,
    this.workEmail,
    this.workPhone,
    this.workMobile,
  });

  final int? id;
  final String? code;
  final String? name;
  final String? imageUrl;
  final String? gender;
  final String? birthday;
  final String? jobTitle;
  final String? department;
  final String? division;
  final String? company;
  final String? jobPosition;
  final String? reference;
  final String? workEmail;
  final String? workPhone;
  final String? workMobile;

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        imageUrl,
        gender,
        birthday,
        jobTitle,
        department,
        division,
        company,
        jobPosition,
        reference,
        workEmail,
        workPhone,
        workMobile,
      ];
}

class UserProfile extends Equatable {
  const UserProfile({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.isActive = true,
    this.isEmailVerified,
    this.devicePlatform,
    this.appVersion,
    this.employee,
  });

  final int? id;
  final String name;
  final String email;
  final String? phone;
  final bool isActive;
  final bool? isEmailVerified;
  final String? devicePlatform;
  final String? appVersion;
  final EmployeeProfile? employee;

  String get displayName {
    if (name.trim().isNotEmpty) return name.trim();
    return employee?.name?.trim() ?? '';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        isActive,
        isEmailVerified,
        devicePlatform,
        appVersion,
        employee,
      ];
}
