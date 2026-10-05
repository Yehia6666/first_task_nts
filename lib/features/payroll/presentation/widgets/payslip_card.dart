import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/payslip.dart';

/// Card for a single payslip.
///
/// [Payslip.dateFrom] is the only typed field on the entity, so it is shown as
/// the card headline. Every other scalar value the API returned is listed
/// underneath, which keeps the screen useful without inventing field names.
class PayslipCard extends StatelessWidget {
  const PayslipCard({super.key, required this.payslip});

  final Payslip payslip;

  /// Scalar entries of the response, excluding the headline date.
  static List<MapEntry<String, String>> _details(Map<String, dynamic> raw) {
    final details = <MapEntry<String, String>>[];
    raw.forEach((key, value) {
      if (key == 'date_from' || value == null) return;
      if (value is Map || value is List) return;
      details.add(MapEntry(_label(key), value.toString()));
    });
    return details;
  }

  /// Turns `basic_salary` into `Basic salary` without assuming a field name.
  static String _label(String key) {
    final spaced = key.replaceAll('_', ' ').trim();
    if (spaced.isEmpty) return key;
    return spaced[0].toUpperCase() + spaced.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final details = _details(payslip.raw);

    return AppCard(
      radius: AppRadius.xl,
      showShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payslip', style: AppTextStyles.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      payslip.dateFrom.isEmpty
                          ? 'No period start date'
                          : payslip.dateFrom,
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (details.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            for (final detail in details)
              _PayslipDetailRow(label: detail.key, value: detail.value),
          ],
        ],
      ),
    );
  }
}

class _PayslipDetailRow extends StatelessWidget {
  const _PayslipDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.overline.copyWith(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1, color: AppColors.border),
        ],
      ),
    );
  }
}
