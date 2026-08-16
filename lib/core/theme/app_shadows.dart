import 'package:flutter/material.dart';

/// Soft, low-opacity shadows. One elevation tier for cards, one lighter tier
/// for floating elements like the search field.
abstract final class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0A1A1D2E),
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> subtle = [
    BoxShadow(
      color: Color(0x081A1D2E),
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow> glow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.35),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];
}
