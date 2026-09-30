import 'package:first_task_nts/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class TimeOffTaps extends StatelessWidget {
  const TimeOffTaps({super.key, required this.isSlected, required this.titel});
  final bool isSlected;
  final String titel;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        titel,
        maxLines: 1,
        softWrap: false,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
      ),
    );
  }
}
