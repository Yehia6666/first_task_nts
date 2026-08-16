import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_responsive.dart';

/// Simple app header: optional leading/trailing widgets around a large bold
/// navy title. Borderless, minimal.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.pagePadding(context),
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          ?leading,
          if (leading != null) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.headline,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null) const SizedBox(width: AppSpacing.sm),
          ?trailing,
        ],
      ),
    );
  }
}
