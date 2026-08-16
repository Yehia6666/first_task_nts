import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Circular floating action button. Dark navy by default (per expenses
/// reference), white icon, subtle shadow.
class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.background = AppColors.textPrimary,
    this.foreground = AppColors.onPrimary,
    this.size = 56,
    this.tooltip,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Color background;
  final Color foreground;
  final double size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: SizedBox(
        width: size,
        height: size,
        child: Material(
          color: background,
          elevation: 4,
          shadowColor: AppColors.shadow,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Icon(icon, size: size * 0.43, color: foreground),
          ),
        ),
      ),
    );
  }
}
