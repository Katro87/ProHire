import 'package:flutter/material.dart';

/// Responsive layout utility class for handling different screen sizes
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
  static late bool isMobile;
  static late bool isTablet;
  static late bool isDesktop;
  static late double textScaleFactor;
  
  // Base design dimensions (iPhone X/11 Pro)
  static const double baseWidth = 375.0;
  static const double baseHeight = 812.0;
  
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
    
    textScaleFactor = _mediaQueryData.textScaler.scale(1.0);
    
    // Device type detection
    isMobile = screenWidth < 600;
    isTablet = screenWidth >= 600 && screenWidth < 1200;
    isDesktop = screenWidth >= 1200;
  }
  
  /// Get proportional width based on design width (375px base)
  static double width(double inputWidth) {
    return (inputWidth / baseWidth) * screenWidth;
  }
  
  /// Get proportional height based on design height (812px base)
  static double height(double inputHeight) {
    return (inputHeight / baseHeight) * screenHeight;
  }
  
  /// Get responsive font size
  static double fontSize(double size) {
    double scaleFactor = screenWidth / baseWidth;
    // Limit scale factor to prevent text from getting too large on tablets/desktops
    scaleFactor = scaleFactor.clamp(0.8, 1.5);
    return size * scaleFactor;
  }
  
  /// Get responsive spacing
  static double spacing(double size) {
    return width(size);
  }
  
  /// Get responsive radius
  static double radius(double size) {
    return width(size);
  }
  
  /// Get safe area top padding
  static double get safeTop => _mediaQueryData.padding.top;
  
  /// Get safe area bottom padding
  static double get safeBottom => _mediaQueryData.padding.bottom;
  
  /// Get content width (screen width minus margins)
  static double contentWidth({double margin = 24}) {
    return screenWidth - (margin * 2);
  }
  
  /// Get max content width (constrained for larger screens)
  static double maxContentWidth({double maxWidth = 500, double margin = 24}) {
    double content = screenWidth - (margin * 2);
    return content > maxWidth ? maxWidth : content;
  }
  
  /// Check if device is in landscape mode
  static bool get isLandscape => screenWidth > screenHeight;
  
  /// Get number of grid columns based on screen width
  static int get gridColumns {
    if (screenWidth >= 1200) return 4;
    if (screenWidth >= 900) return 3;
    if (screenWidth >= 600) return 3;
    return 2;
  }
  
  /// Get responsive padding
  static EdgeInsets get screenPadding {
    return EdgeInsets.symmetric(
      horizontal: width(24),
      vertical: height(16),
    );
  }
  
  /// Get responsive horizontal padding
  static EdgeInsets horizontalPadding([double value = 24]) {
    return EdgeInsets.symmetric(horizontal: width(value));
  }
  
  /// Get responsive vertical padding
  static EdgeInsets verticalPadding([double value = 16]) {
    return EdgeInsets.symmetric(vertical: height(value));
  }
}

/// Extension methods for responsive design
extension ResponsiveExtension on num {
  /// Responsive width
  double get w => Responsive.width(toDouble());
  
  /// Responsive height
  double get h => Responsive.height(toDouble());
  
  /// Responsive font size
  double get sp => Responsive.fontSize(toDouble());
  
  /// Responsive radius
  double get r => Responsive.radius(toDouble());
}

/// Widget that provides responsive layout capabilities
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

/// Widget that shows different layouts based on screen size
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    if (Responsive.isDesktop && desktop != null) {
      return desktop!;
    }
    
    if (Responsive.isTablet && tablet != null) {
      return tablet!;
    }
    
    return mobile;
  }
}

/// Constrained width container for larger screens
class ContentContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;
  final AlignmentGeometry alignment;
  
  const ContentContainer({
    super.key,
    required this.child,
    this.maxWidth = 500,
    this.padding,
    this.alignment = Alignment.center,
  });
  
  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: padding ?? Responsive.horizontalPadding(),
        child: child,
      ),
    );
  }
}
