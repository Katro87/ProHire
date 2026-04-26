import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors - Premium Purple & Teal
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color primaryDark = Color(0xFF5B21B6);
  static const Color primarySurface = Color(0xFFF5F3FF);

  static const Color secondary = Color(0xFF14B8A6);
  static const Color secondaryLight = Color(0xFF2DD4BF);
  static const Color secondaryDark = Color(0xFF0F766E);
  static const Color secondarySurface = Color(0xFFF0FDFA);

  // Trade Professional Colors - Warm Orange/Amber
  static const Color trade = Color(0xFFEA580C);
  static const Color tradeLight = Color(0xFFFB923C);
  static const Color tradeDark = Color(0xFFC2410C);
  static const Color tradeSurface = Color(0xFFFFF7ED);

  // Freelancer Colors - Cool Blue
  static const Color freelance = Color(0xFF2563EB);
  static const Color freelanceLight = Color(0xFF60A5FA);
  static const Color freelanceDark = Color(0xFF1D4ED8);
  static const Color freelanceSurface = Color(0xFFEFF6FF);

  // Light Theme
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF18181B);
  static const Color textSecondaryLight = Color(0xFF52525B);
  static const Color textTertiaryLight = Color(0xFFA1A1AA);
  static const Color dividerLight = Color(0xFFE4E4E7);
  static const Color borderLight = Color(0xFFD4D4D8);

  // Dark Theme
  static const Color backgroundDark = Color(0xFF09090B);
  static const Color surfaceDark = Color(0xFF18181B);
  static const Color cardDark = Color(0xFF27272A);
  static const Color textPrimaryDark = Color(0xFFFAFAFA);
  static const Color textSecondaryDark = Color(0xFFA1A1AA);
  static const Color textTertiaryDark = Color(0xFF71717A);
  static const Color dividerDark = Color(0xFF3F3F46);
  static const Color borderDark = Color(0xFF52525B);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Ratings
  static const Color starFilled = Color(0xFFFBBF24);
  static const Color starEmpty = Color(0xFFE4E4E7);

  // Premium Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C3AED), Color(0xFFA855F7), Color(0xFF6366F1)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF14B8A6), Color(0xFF06B6D4)],
  );

  static const LinearGradient tradeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEA580C), Color(0xFFF97316), Color(0xFFFB923C)],
  );

  static const LinearGradient freelanceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6), Color(0xFF60A5FA)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF18181B), Color(0xFF27272A)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
    colors: [Color(0xFF7C3AED), Color(0xFF5B21B6), Color(0xFF3B0764)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFE4E4E7),
      Color(0xFFF4F4F5),
      Color(0xFFE4E4E7),
    ],
  );

  // Glass Effects
  static Color glassWhite(double opacity) => Colors.white.withValues(alpha: opacity);
  static Color glassBlack(double opacity) => Colors.black.withValues(alpha: opacity);
  static Color glassPrimary(double opacity) => primary.withValues(alpha: opacity);

  // Shadows
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 30,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get mediumShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 40,
          offset: const Offset(0, 15),
        ),
      ];

  static List<BoxShadow> get strongShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 50,
          offset: const Offset(0, 20),
        ),
      ];

  static List<BoxShadow> primaryGlow(double opacity) => [
        BoxShadow(
          color: primary.withValues(alpha: opacity),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> tradeGlow(double opacity) => [
        BoxShadow(
          color: trade.withValues(alpha: opacity),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> freelanceGlow(double opacity) => [
        BoxShadow(
          color: freelance.withValues(alpha: opacity),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
}
