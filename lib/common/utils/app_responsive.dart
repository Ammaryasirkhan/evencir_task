import 'package:flutter/widgets.dart';

class AppResponsive {
  const AppResponsive._();

  static bool isSmallPhone(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 360;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 700;

  static double horizontalPadding(BuildContext context) {
    if (isTablet(context)) return 28;
    if (isSmallPhone(context)) return 16;
    return 20;
  }
}
