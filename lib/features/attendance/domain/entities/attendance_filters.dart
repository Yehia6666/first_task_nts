/// Filter options exposed to the UI. The filtering logic itself lives in
/// the `FilterAttendanceLogs` use case.
enum AttendanceTypeFilter { all, checkIn, checkOut }

enum AttendanceStatusFilter { all, completed, pending }
