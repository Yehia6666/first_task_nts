import '../../domain/entities/attendance_log.dart';

class AttendanceLogModel extends AttendanceLog {
  const AttendanceLogModel({
    required super.id,
    required super.type,
    required super.date,
    required super.time,
    required super.location,
    required super.status,
    super.workedHours,
  });

  factory AttendanceLogModel.fromJson(Map<String, dynamic> json) {
    return AttendanceLogModel(
      id: json['id'] as String,
      type: AttendanceType.values.byName(json['type'] as String),
      date: DateTime.parse(json['date'] as String),
      time: DateTime.parse(json['time'] as String),
      location: json['location'] as String,
      status: AttendanceStatus.values.byName(json['status'] as String),
      workedHours: (json['workedHours'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'date': date.toIso8601String(),
        'time': time.toIso8601String(),
        'location': location,
        'status': status.name,
        'workedHours': workedHours,
      };

  AttendanceLog toEntity() => AttendanceLog(
        id: id,
        type: type,
        date: date,
        time: time,
        location: location,
        status: status,
        workedHours: workedHours,
      );
}
