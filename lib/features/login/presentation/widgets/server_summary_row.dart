import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../connection/domain/entities/validated_database.dart';

class ServerSummaryRow extends StatelessWidget {
  const ServerSummaryRow({super.key, required this.database});

  final ValidatedDatabase database;

  @override
  Widget build(BuildContext context) {
    final String name = database.database;
    final String host = database.baseUrl.value.host;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          const Icon(Icons.storage_outlined, size: 22, color: AppColors.teal),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: name.isEmpty
                ? Text(
                    host,
                    style: AppTextStyles.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.titleMedium.copyWith(fontSize: 17),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        host,
                        style: AppTextStyles.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
