/// Small, dependency-free formatting helpers shared across features.
abstract final class AppFormatters {
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const List<String> _weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  /// Formats a time as `09:00 AM`.
  static String timeOfDay(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} '
        '${time.hour < 12 ? 'AM' : 'PM'}';
  }

  /// Formats a time with seconds as `02:34:23 PM` (live clock on Home).
  static String timeOfDayWithSeconds(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    return '${hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')} '
        '${time.hour < 12 ? 'AM' : 'PM'}';
  }

  /// Formats a day as `Monday, Aug 10`.
  static String day(DateTime date) {
    final weekday = _weekdays[date.weekday - 1];
    return '$weekday, ${_months[date.month - 1]} ${date.day}';
  }

  /// Formats a date as `8/1/2026`.
  static String shortDate(DateTime date) =>
      '${date.month}/${date.day}/${date.year}';

  /// Formats an amount as `$45.00`.
  static String currency(double amount) => '\$${amount.toStringAsFixed(2)}';
}
