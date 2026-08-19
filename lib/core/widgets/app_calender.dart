import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AppCalender extends StatefulWidget {
  const AppCalender({super.key});

  @override
  State<AppCalender> createState() => _AppCalenderState();
}

class _AppCalenderState extends State<AppCalender> {
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime doucsedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: "en_US",
      rowHeight: 30,
      calendarStyle: CalendarStyle(
        cellPadding: EdgeInsets.zero,
        cellMargin: EdgeInsets.zero,
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: false,
      ),
      availableGestures: AvailableGestures.all,
      focusedDay: today,
      selectedDayPredicate: (day) => isSameDay(day, today),
      firstDay: DateTime.utc(2020, 12, 30),
      lastDay: DateTime.utc(2027, 12, 30),
      onDaySelected: _onDaySelected,
    );
  }
}
