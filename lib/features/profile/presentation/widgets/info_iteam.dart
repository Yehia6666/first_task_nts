import 'package:first_task_nts/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class InfoIteam extends StatelessWidget {
  const InfoIteam({super.key, required this.titel, required this.data});
  final String titel;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titel,
          style: AppTextStyles.bodyMedium.copyWith(
            height: 0.8,
            color: Colors.grey[400],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(data, style: AppTextStyles.titleSmall),
        Divider(color: Colors.grey[100]),
        SizedBox(height: 4),
      ],
    );
  }
}
