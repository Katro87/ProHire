import 'package:flutter/material.dart';

class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late bool isPhone;
  static late bool isTablet;
  static late bool isDesktop;
  static late bool isLandscape;
  static late double textScaleFactor;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    
    safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;
    
    isLandscape = screenWidth > screenHeight;
    isPhone = screenWidth < 600;
    isTablet = screenWidth >= 600 && screenWidth < 1200;
    isDesktop = screenWidth >= 1200;
    
    textScaleFactor = _calculateTextScaleFactor();
  }

  static double _calculateTextScaleFactor() {
    if (screenWidth < 360) return 0.85;
    if (screenWidth < 400) return 0.9;
    if (screenWidth < 600) return 1.0;
    if (screenWidth < 900) return 1.1;
    return 1.15;
  }

  // Responsive width based on percentage
  static double wp(double percentage) => screenWidth * (percentage / 100);
  
  // Responsive height based on percentage
  static double hp(double percentage) => screenHeight * (percentage / 100);
  
  // Responsive font size
  static double sp(double size) => size * textScaleFactor;
  
  // Responsive spacing (8px grid system)
  static double spacing(double multiplier) => 8 * multiplier;
  
  // Get grid column count based on screen size
  static int getGridColumnCount({int small = 2, int medium = 3, int large = 4}) {
    if (isPhone && !isLandscape) return small;
    if ((isPhone && isLandscape) || (isTablet && !isLandscape)) return medium;
    return large;
  }
  
  // Get card width for current screen
  static double getCardWidth({double padding = 16}) {
    int columns = getGridColumnCount();
    double totalPadding = padding * (columns + 1);
    return (screenWidth - totalPadding) / columns;
  }

  // Get horizontal padding based on screen size
  static double getHorizontalPadding() {
    if (isPhone) return 16;
    if (isTablet) return 24;
    return 32;
  }

  // Get vertical padding based on screen size
  static double getVerticalPadding() {
    if (isPhone) return 16;
    if (isTablet) return 20;
    return 24;
  }
  
  // Get appropriate icon size
  static double getIconSize({double base = 24}) {
    if (isPhone) return base;
    if (isTablet) return base * 1.2;
    return base * 1.4;
  }

  // Get appropriate avatar size
  static double getAvatarSize({double base = 48}) {
    if (isPhone) return base;
    if (isTablet) return base * 1.25;
    return base * 1.5;
  }
}

// Responsive Builder Widget
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints) builder;
  
  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Responsive.init(context);
        return builder(context, constraints);
      },
    );
  }
}

// Device Type Responsive Widget
class DeviceTypeBuilder extends StatelessWidget {
  final Widget phone;
  final Widget? tablet;
  final Widget? desktop;
  
  const DeviceTypeBuilder({
    super.key,
    required this.phone,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Responsive.init(context);
        if (Responsive.isDesktop && desktop != null) return desktop!;
        if (Responsive.isTablet && tablet != null) return tablet!;
        return phone;
      },
    );
  }
}

// Extension for responsive sizing
extension ResponsiveSize on num {
  double get w => Responsive.wp(toDouble());
  double get h => Responsive.hp(toDouble());
  double get sp => Responsive.sp(toDouble());
}
