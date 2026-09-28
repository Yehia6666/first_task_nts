abstract final class AppFormatters {
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const List<String> _weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  static String timeOfDay(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} '
        '${time.hour < 12 ? 'AM' : 'PM'}';
  }

  static String timeOfDayWithSeconds(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    return '${hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')} '
        '${time.hour < 12 ? 'AM' : 'PM'}';
  }

  static String day(DateTime date) {
    final weekday = _weekdays[date.weekday - 1];
    return '$weekday, ${_months[date.month - 1]} ${date.day}';
  }

  static String shortDate(DateTime date) =>
      '${date.month}/${date.day}/${date.year}';

  static String currency(double amount) => '\$${amount.toStringAsFixed(2)}';
}
