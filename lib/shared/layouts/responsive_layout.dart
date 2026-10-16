import 'package:flutter/material.dart';

class ResponsiveLayout {
  static const double mobile = 600;
  static const double tablet = 1024;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tablet;
  }

  static int dashboardColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1400) return 4;
    if (width >= 1000) return 3;
    if (width >= 600) return 2;
    return 1;
  }
}
