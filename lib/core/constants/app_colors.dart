import 'package:flutter/material.dart';

/// Central color palette — the single source of truth for every color used
/// in the app. Never hard-code hex values inside widgets.
abstract final class AppColors {
  static const Color background = Color(0xFFF4F5FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F1F7);
  static const Color border = Color(0xFFE7E9F2);

  static const Color textPrimary = Color(0xFF171B2E);
  static const Color textSecondary = Color(0xFF5A607A);
  static const Color textMuted = Color(0xFF9AA0B4);

  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryDark = Color(0xFF4338CA);
  static const Color primaryContainer = Color(0xFFE9E9FC);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF22C55E);
  static const Color successContainer = Color(0xFFE8F8EE);
  static const Color successDark = Color(0xFF16A34A);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFFFEF3E0);
  static const Color warningDark = Color(0xFFD97706);

  static const Color error = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFFFDE9E9);
  static const Color errorDark = Color(0xFFDC2626);

  static const Color infoBlue = Color(0xFF3B82F6);
  static const Color infoBlueContainer = Color(0xFFEAF1FE);

  static const Color accentViolet = Color(0xFF8B5CF6);
  static const Color accentVioletContainer = Color(0xFFF2ECFE);

  static const Color shadow = Color(0xFF1A1D2E);
}
