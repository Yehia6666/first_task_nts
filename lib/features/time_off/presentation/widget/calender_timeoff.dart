import 'package:first_task_nts/core/widgets/app_calender.dart';
import 'package:first_task_nts/features/time_off/presentation/widget/states_order_timeoff.dart';
import 'package:flutter/material.dart';

class CalenderTimeoff extends StatelessWidget {
  const CalenderTimeoff({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.4;
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 4,
            spreadRadius: 0.2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
         AppCalender(),
          Row(
            children: [
              StatesOrderTimeoff(
                pointColor: Colors.lightGreenAccent,
                states: 'APPROVED',
              ),
              StatesOrderTimeoff(pointColor: Colors.amber, states: 'PENDING'),
            ],
          ),
        ],
      ),
    );
  }
}
