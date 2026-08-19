import 'package:first_task_nts/core/theme/app_text_styles.dart';
import 'package:first_task_nts/core/widgets/app_drawer.dart';
import 'package:first_task_nts/features/time_off/presentation/widget/calender_timeoff.dart';
import 'package:first_task_nts/features/time_off/presentation/widget/time_off_taps.dart';
import 'package:flutter/material.dart';

class TimeOffScreen extends StatelessWidget {
  const TimeOffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        drawer: const AppDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          title: Text('Time Off', style: AppTextStyles.titleLarge),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 22),
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                dividerHeight: 0,
                indicatorPadding: EdgeInsetsGeometry.symmetric(
                  horizontal: -12,
                  vertical: -6,
                ),
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                tabs: [
                  TimeOffTaps(isSlected: false, titel: 'My Requests'),
                  TimeOffTaps(isSlected: false, titel: 'Balance'),
                  TimeOffTaps(isSlected: false, titel: 'Allocations'),
                  TimeOffTaps(isSlected: true, titel: 'Calendar'),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsetsGeometry.all(20),
          child: TabBarView(
            children: [
              Text('My Requestes'),
              Text('Balance'),
              Text('Allocations'),
              CalenderTimeoff(),
            ],
          ),
        ),
      ),
    );
  }
}
