import '../../domain/entities/attendance_session.dart';

class AttendanceSessionModel extends AttendanceSession {
  const AttendanceSessionModel({
    required super.id,
    required super.date,
    required super.earliestEvent,
    required super.targetEnd,
    required super.location,
    required super.status,
    super.checkInAt,
  });

  factory AttendanceSessionModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSessionModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      earliestEvent: DateTime.parse(json['earliestEvent'] as String),
      targetEnd: DateTime.parse(json['targetEnd'] as String),
      location: json['location'] as String,
      status: AttendanceSessionStatus.values.byName(json['status'] as String),
      checkInAt: json['checkInAt'] == null
          ? null
          : DateTime.parse(json['checkInAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'earliestEvent': earliestEvent.toIso8601String(),
        'targetEnd': targetEnd.toIso8601String(),
        'location': location,
        'status': status.name,
        'checkInAt': checkInAt?.toIso8601String(),
      };

  AttendanceSessionModel copyWith({
    AttendanceSessionStatus? status,
    DateTime? checkInAt,
    bool clearCheckInAt = false,
  }) {
    return AttendanceSessionModel(
      id: id,
      date: date,
      earliestEvent: earliestEvent,
      targetEnd: targetEnd,
      location: location,
      status: status ?? this.status,
      checkInAt: clearCheckInAt ? null : (checkInAt ?? this.checkInAt),
    );
  }

  AttendanceSession toEntity() => AttendanceSession(
        id: id,
        date: date,
        earliestEvent: earliestEvent,
        targetEnd: targetEnd,
        location: location,
        status: status,
        checkInAt: checkInAt,
      );
}
