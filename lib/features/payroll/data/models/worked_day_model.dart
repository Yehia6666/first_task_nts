import '../../domain/entities/worked_day.dart';

class WorkedDayModel extends WorkedDay {
  const WorkedDayModel({
    required super.id,
    required super.code,
    required super.name,
    required super.numberOfDays,
    required super.numberOfHours,
    required super.amount,
  });

  factory WorkedDayModel.fromJson(Map<String, dynamic> json) {
    return WorkedDayModel(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      numberOfDays: json['number_of_days'] as num? ?? 0,
      numberOfHours: json['number_of_hours'] as num? ?? 0,
      amount: json['amount'] as num? ?? 0,
    );
  }
}
