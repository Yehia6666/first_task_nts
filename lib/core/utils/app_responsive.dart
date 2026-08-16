import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

enum DeviceClass { mobile, tablet, desktop }

/// Responsive helpers. Breakpoints follow the Design System skill:
/// mobile < 600, tablet 600–1024, desktop ≥ 1024.
abstract final class AppResponsive {
  static const double mobileBreakpoint = 600;
  static const double desktopBreakpoint = 1024;

  static DeviceClass of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktopBreakpoint) return DeviceClass.desktop;
    if (width >= mobileBreakpoint) return DeviceClass.tablet;
    return DeviceClass.mobile;
  }

  static bool isMobile(BuildContext context) => of(context) == DeviceClass.mobile;
  static bool isTablet(BuildContext context) => of(context) == DeviceClass.tablet;
  static bool isDesktop(BuildContext context) => of(context) == DeviceClass.desktop;

  /// Horizontal page padding: 20 on compact phones, 24 on larger screens.
  static double pagePadding(BuildContext context) =>
      isMobile(context) ? AppSpacing.xl : AppSpacing.xxl;
}
