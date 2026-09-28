import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

enum DeviceClass { mobile, tablet, desktop }

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

  static double pagePadding(BuildContext context) =>
      isMobile(context) ? AppSpacing.xl : AppSpacing.xxl;
}
