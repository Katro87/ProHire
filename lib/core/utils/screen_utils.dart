import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Breakpoints for responsive design
class Breakpoints {
  static const double mobileSmall = 320;
  static const double mobile = 375;
  static const double mobileLarge = 414;
  static const double tablet = 600;
  static const double tabletLarge = 900;
  static const double desktop = 1200;
  static const double desktopLarge = 1440;
}

/// Device type enum
enum DeviceType { mobileSmall, mobile, mobileLarge, tablet, tabletLarge, desktop }

/// Screen information class - use this inside widgets
class ScreenInfo {
  final double width;
  final double height;
  final double safeTop;
  final double safeBottom;
  final double safeLeft;
  final double safeRight;
  final DeviceType deviceType;
  final bool isLandscape;
  final double textScale;
  final double pixelRatio;

  const ScreenInfo({
    required this.width,
    required this.height,
    required this.safeTop,
    required this.safeBottom,
    required this.safeLeft,
    required this.safeRight,
    required this.deviceType,
    required this.isLandscape,
    required this.textScale,
    required this.pixelRatio,
  });

  double get safeWidth => width - safeLeft - safeRight;
  double get safeHeight => height - safeTop - safeBottom;

  bool get isMobile => deviceType == DeviceType.mobileSmall || 
                       deviceType == DeviceType.mobile || 
                       deviceType == DeviceType.mobileLarge;
  bool get isTablet => deviceType == DeviceType.tablet || 
                       deviceType == DeviceType.tabletLarge;
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Get horizontal padding - ensures content doesn't touch edges
  double get horizontalPadding {
    if (isDesktop) return math.max(32, (width - 1200) / 2);
    if (isTablet) return 24;
    if (deviceType == DeviceType.mobileSmall) return 12;
    return 16;
  }

  /// Get vertical section padding
  double get sectionPadding {
    if (isDesktop) return 32;
    if (isTablet) return 24;
    return 20;
  }

  /// Get grid columns based on content type
  int gridColumns({int mobileCount = 2, int tabletCount = 3, int desktopCount = 4}) {
    if (isLandscape && isMobile) return mobileCount + 1;
    if (isDesktop) return desktopCount;
    if (isTablet) return tabletCount;
    return mobileCount;
  }

  /// Calculate card width that fits properly
  double cardWidth({required int columns, double spacing = 12}) {
    final totalSpacing = spacing * (columns + 1);
    final availableWidth = safeWidth - totalSpacing;
    return math.max(140, availableWidth / columns);
  }

  /// Responsive font size - clamped to prevent extreme sizes
  double fontSize(double base) {
    double scale = 1.0;
    if (deviceType == DeviceType.mobileSmall) scale = 0.85;
    else if (deviceType == DeviceType.mobile) scale = 0.92;
    else if (deviceType == DeviceType.mobileLarge) scale = 1.0;
    else if (deviceType == DeviceType.tablet) scale = 1.08;
    else if (deviceType == DeviceType.tabletLarge) scale = 1.12;
    else scale = 1.15;
    
    return (base * scale).clamp(base * 0.75, base * 1.3);
  }

  /// Responsive icon size
  double iconSize(double base) {
    if (isDesktop) return base * 1.3;
    if (isTablet) return base * 1.15;
    return base;
  }

  /// Responsive spacing
  double spacing(double base) {
    if (deviceType == DeviceType.mobileSmall) return base * 0.8;
    if (isDesktop) return base * 1.2;
    if (isTablet) return base * 1.1;
    return base;
  }

  /// Max content width for large screens
  double get maxContentWidth {
    if (isDesktop) return 1200;
    if (isTablet) return 800;
    return width;
  }

  /// Get constrained width for content
  double get contentWidth => math.min(width, maxContentWidth);
}

/// Provider widget for screen info
class ResponsiveProvider extends InheritedWidget {
  final ScreenInfo screenInfo;

  const ResponsiveProvider({
    super.key,
    required this.screenInfo,
    required super.child,
  });

  static ScreenInfo of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ResponsiveProvider>();
    assert(provider != null, 'ResponsiveProvider not found in widget tree');
    return provider!.screenInfo;
  }

  static ScreenInfo? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ResponsiveProvider>()?.screenInfo;
  }

  @override
  bool updateShouldNotify(ResponsiveProvider oldWidget) {
    return screenInfo.width != oldWidget.screenInfo.width ||
           screenInfo.height != oldWidget.screenInfo.height;
  }
}

/// Wrapper widget that provides responsive context
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Get MediaQuery once at the top level to avoid context issues
    final mediaQuery = MediaQuery.of(context);
    
    return LayoutBuilder(
      builder: (layoutContext, constraints) {
        final width = constraints.maxWidth.isFinite 
            ? constraints.maxWidth 
            : mediaQuery.size.width;
        final height = constraints.maxHeight.isFinite 
            ? constraints.maxHeight 
            : mediaQuery.size.height;

        final deviceType = _getDeviceType(width);

        final screenInfo = ScreenInfo(
          width: width,
          height: height,
          safeTop: mediaQuery.padding.top,
          safeBottom: mediaQuery.padding.bottom,
          safeLeft: mediaQuery.padding.left,
          safeRight: mediaQuery.padding.right,
          deviceType: deviceType,
          isLandscape: width > height,
          textScale: mediaQuery.textScaler.scale(1.0),
          pixelRatio: mediaQuery.devicePixelRatio,
        );

        return ResponsiveProvider(
          screenInfo: screenInfo,
          child: child,
        );
      },
    );
  }

  DeviceType _getDeviceType(double width) {
    if (width < Breakpoints.mobileSmall + 40) return DeviceType.mobileSmall;
    if (width < Breakpoints.mobile + 40) return DeviceType.mobile;
    if (width < Breakpoints.tablet) return DeviceType.mobileLarge;
    if (width < Breakpoints.tabletLarge) return DeviceType.tablet;
    if (width < Breakpoints.desktop) return DeviceType.tabletLarge;
    return DeviceType.desktop;
  }
}

/// Builder widget for responsive layouts
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenInfo screen) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    // Get MediaQuery once at the top level to avoid context issues
    final mediaQuery = MediaQuery.of(context);
    
    return LayoutBuilder(
      builder: (layoutContext, constraints) {
        final width = constraints.maxWidth.isFinite 
            ? constraints.maxWidth 
            : mediaQuery.size.width;
        final height = constraints.maxHeight.isFinite 
            ? constraints.maxHeight 
            : mediaQuery.size.height;

        final deviceType = _getDeviceType(width);

        final screenInfo = ScreenInfo(
          width: width,
          height: height,
          safeTop: mediaQuery.padding.top,
          safeBottom: mediaQuery.padding.bottom,
          safeLeft: mediaQuery.padding.left,
          safeRight: mediaQuery.padding.right,
          deviceType: deviceType,
          isLandscape: width > height,
          textScale: mediaQuery.textScaler.scale(1.0),
          pixelRatio: mediaQuery.devicePixelRatio,
        );

        // Use the original context, not the LayoutBuilder context
        return builder(context, screenInfo);
      },
    );
  }

  DeviceType _getDeviceType(double width) {
    if (width < Breakpoints.mobileSmall + 40) return DeviceType.mobileSmall;
    if (width < Breakpoints.mobile + 40) return DeviceType.mobile;
    if (width < Breakpoints.tablet) return DeviceType.mobileLarge;
    if (width < Breakpoints.tabletLarge) return DeviceType.tablet;
    if (width < Breakpoints.desktop) return DeviceType.tabletLarge;
    return DeviceType.desktop;
  }
}

/// Device-specific widget builder
class DeviceBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const DeviceBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1200;
    final isTablet = width >= 600 && width < 1200;
    
    if (isDesktop && desktop != null) return desktop!;
    if (isTablet && tablet != null) return tablet!;
    return mobile;
  }
}

/// Constrained content wrapper - prevents overflow on large screens
class ContentConstraint extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;
  final Alignment alignment;

  const ContentConstraint({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.padding,
    this.alignment = Alignment.center,
  });

  double _getHorizontalPadding(double width) {
    if (width >= 1200) return math.max(32, (width - 1200) / 2);
    if (width >= 600) return 24;
    if (width < 360) return 12;
    return 16;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final effectivePadding = padding ?? EdgeInsets.symmetric(
      horizontal: _getHorizontalPadding(width),
    );

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: effectivePadding,
        child: child,
      ),
    );
  }
}

/// Adaptive grid that prevents overflow
class AdaptiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int minCrossAxisCount;
  final int maxCrossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsets? padding;
  final double minChildWidth;

  const AdaptiveGrid({
    super.key,
    required this.children,
    this.minCrossAxisCount = 1,
    this.maxCrossAxisCount = 4,
    this.childAspectRatio = 1.0,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 12,
    this.padding,
    this.minChildWidth = 150,
  });

  double _getHorizontalPadding(double width) {
    if (width >= 1200) return math.max(32, (width - 1200) / 2);
    if (width >= 600) return 24;
    if (width < 360) return 12;
    return 16;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final safeLeft = mediaQuery.padding.left;
    final safeRight = mediaQuery.padding.right;
    final safeWidth = width - safeLeft - safeRight;
    final horizontalPadding = _getHorizontalPadding(width);
    
    // Calculate columns based on available width
    final availableWidth = safeWidth - 
        (padding?.horizontal ?? horizontalPadding * 2);
    
    int columns = (availableWidth / (minChildWidth + crossAxisSpacing)).floor();
    columns = columns.clamp(minCrossAxisCount, maxCrossAxisCount);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: horizontalPadding,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Sliver version of adaptive grid
class SliverAdaptiveGrid extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final int minCrossAxisCount;
  final int maxCrossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double minChildWidth;

  const SliverAdaptiveGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.minCrossAxisCount = 1,
    this.maxCrossAxisCount = 4,
    this.childAspectRatio = 1.0,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 12,
    this.minChildWidth = 150,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen info directly from MediaQuery to avoid LayoutBuilder issues in slivers
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final safeLeft = mediaQuery.padding.left;
    final safeRight = mediaQuery.padding.right;
    final safeWidth = width - safeLeft - safeRight;
    
    // Calculate horizontal padding based on screen width
    double horizontalPadding;
    if (width >= 1200) {
      horizontalPadding = math.max(32, (width - 1200) / 2);
    } else if (width >= 600) {
      horizontalPadding = 24;
    } else if (width < 360) {
      horizontalPadding = 12;
    } else {
      horizontalPadding = 16;
    }
    
    final availableWidth = safeWidth - (horizontalPadding * 2);
    int columns = (availableWidth / (minChildWidth + crossAxisSpacing)).floor();
    columns = columns.clamp(minCrossAxisCount, maxCrossAxisCount);

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          childAspectRatio: childAspectRatio,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
        ),
        delegate: SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
        ),
      ),
    );
  }
}

/// Safe scrollable column that prevents overflow
class SafeColumn extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsets? padding;
  final bool scrollable;

  const SafeColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.padding,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final column = Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );

    if (!scrollable) {
      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: column,
      );
    }

    return SingleChildScrollView(
      padding: padding,
      child: column,
    );
  }
}

/// Extension for easy access to screen info
extension ScreenInfoExtension on BuildContext {
  ScreenInfo get screen => ResponsiveProvider.of(this);
  ScreenInfo? get maybeScreen => ResponsiveProvider.maybeOf(this);
}
