import 'package:first_task_nts/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class StatesOrderTimeoff extends StatelessWidget {
  const StatesOrderTimeoff({
    super.key,
    required this.pointColor,
    required this.states,
  });
  final Color pointColor;
  final String states;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: pointColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(states, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}
