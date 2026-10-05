import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
    required this.department,
    required this.employeeId,
  });

  final String name;
  final String email;
  final String phone;
  final String company;
  final String department;
  final String employeeId;

  @override
  List<Object> get props => [name, email, phone, company, department, employeeId];
}