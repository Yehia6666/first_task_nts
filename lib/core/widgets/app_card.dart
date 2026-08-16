import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../theme/app_shadows.dart';

/// White rounded surface card. Content-driven (never fixed height), optional
/// hairline border / soft shadow / padding, and optional tap handling.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.radius = AppRadius.lg,
    this.color = AppColors.surface,
    this.showBorder = true,
    this.showShadow = false,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color color;
  final bool showBorder;
  final bool showShadow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: showBorder ? Border.all(color: AppColors.border) : null,
      boxShadow: showShadow ? AppShadows.card : null,
    );

    final content = Padding(padding: padding, child: child);

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: Ink(
          decoration: decoration,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: content,
          ),
        ),
      );
    }

    return Container(decoration: decoration, child: content);
  }
}
