import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../theme/app_text_styles.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 36,
    this.showWordmark = true,
    this.wordmark = 'NTS',
  });

  final double size;
  final bool showWordmark;
  final String wordmark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(size * 0.3),
          ),
          alignment: Alignment.center,
          child: Text(
            'N',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (showWordmark) ...[
          const SizedBox(width: 8),
          Text(
            wordmark,
            style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ],
    );
  }
}

class AppLogoImage extends StatelessWidget {
  const AppLogoImage({
    super.key,
    this.size = AppSizes.logoSize,
    this.radius = AppRadius.lg,
  });

  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        'assets/images/logo.jpeg',
        width: size,
        height: size,
        fit: BoxFit.cover,
        semanticLabel: 'App logo',
      ),
    );
  }
}
