import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color primaryPurpleLight = Color(0xFF9F8FFF);
  static const Color lightPurple = Color(0xFFA29BFE);
  static const Color softPurpleBackground = Color(0xFFF5F4FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkText = Color(0xFF2D3436);
  static const Color grayText = Color(0xFF636E72);
  static const Color lightGray = Color(0xFFDFE6E9);
  static const Color borderColor = Color(0xFFE8E6FF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  
  // Pastel Colors
  static const Color pastelPurple = Color(0xFFD4C4FB);
  static const Color pastelPink = Color(0xFFFFD3E0);
  static const Color pastelBlue = Color(0xFFC4E0FB);
  static const Color pastelGreen = Color(0xFFC4FBD4);
  static const Color pastelYellow = Color(0xFFFBF4C4);
  static const Color pastelOrange = Color(0xFFFFE0C4);
  
  // Status Colors
  static const Color success = Color(0xFF00B894);
  static const Color error = Color(0xFFFF7675);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color info = Color(0xFF4A9FEB);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F6FA);
  
  // Typography (for compatibility)
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: grayText,
  );
  
  // Accent Colors
  static const Color coralPink = Color(0xFFFF7675);
  static const Color navyBlue = Color(0xFF4A4E8E);
  static const Color yellowGold = Color(0xFFFDCB6E);
  static const Color successGreen = Color(0xFF00B894);
  static const Color premiumBlue = Color(0xFF4A9FEB);
  static const Color starYellow = Color(0xFFFFD700);
  
  // Interest Colors
  static const Color nutritionBg = Color(0xFFFFE5B4);
  static const Color organicBg = Color(0xFFF0F8E8);
  static const Color meditationBg = Color(0xFFE8F5E9);
  static const Color sportsBg = Color(0xFFFFE8E8);
  static const Color smokeBg = Color(0xFFF5F5F5);
  static const Color sleepBg = Color(0xFFE3F2FD);
  static const Color healthBg = Color(0xFFFFF3E0);
  static const Color runningBg = Color(0xFFF3E5F5);
  static const Color veganBg = Color(0xFFE0F2F1);
  
  // Gender & Additional Colors
  static const Color femaleBg = Color(0xFFFFF0F5);
  static const Color maleBg = Color(0xFFE8F4FD);
  static const Color softPurpleBg = Color(0xFFF5F3FF);
  static const Color borderLight = Color(0xFFEEEEEE);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFF7B6FE8)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF5F4FF), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient playerGradient = LinearGradient(
    colors: [Color(0xFF8B7FED), Color(0xFF6C5CE7)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient selectedCardGradient = LinearGradient(
    colors: [Color(0xFF8B7FED), Color(0xFF6C5CE7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient coralGradient = LinearGradient(
    colors: [Color(0xFFFF9F9F), Color(0xFFFF7675)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF6C85E7), Color(0xFF4A5C8E)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF4A9FEB), Color(0xFF357ABD)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  // Shadows
  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: primaryPurple.withValues(alpha: 0.25),
      offset: const Offset(0, 8),
      blurRadius: 16,
    ),
  ];
  
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      offset: const Offset(0, 8),
      blurRadius: 16,
    ),
  ];
  
  static List<BoxShadow> selectedCardShadow = [
    BoxShadow(
      color: primaryPurple.withValues(alpha: 0.3),
      offset: const Offset(0, 12),
      blurRadius: 24,
    ),
  ];
  
  static List<BoxShadow> albumArtShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      offset: const Offset(0, 20),
      blurRadius: 40,
    ),
  ];
  
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radiusXXLarge = 24.0;
  static const double radiusRound = 28.0;
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'SF Pro Display',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: darkText,
    height: 1.2,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontFamily: 'SF Pro Display',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: darkText,
    height: 1.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontFamily: 'SF Pro Display',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: darkText,
  );
  
  static const TextStyle heading4 = TextStyle(
    fontFamily: 'SF Pro Display',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: darkText,
  );
  
  static const TextStyle heading5 = TextStyle(
    fontFamily: 'SF Pro Display',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: darkText,
  );
  
  static const TextStyle bodyText = TextStyle(
    fontFamily: 'SF Pro Text',
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: grayText,
    height: 1.5,
  );
  
  static const TextStyle bodyTextMedium = TextStyle(
    fontFamily: 'SF Pro Text',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: darkText,
  );
  
  static const TextStyle bodyTextSemiBold = TextStyle(
    fontFamily: 'SF Pro Text',
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: white,
  );
  
  static const TextStyle smallText = TextStyle(
    fontFamily: 'SF Pro Text',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: grayText,
  );
  
  static const TextStyle tinyText = TextStyle(
    fontFamily: 'SF Pro Text',
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: grayText,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontFamily: 'SF Pro Text',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: white,
  );
  
  static const TextStyle linkText = TextStyle(
    fontFamily: 'SF Pro Text',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: primaryPurple,
  );
  
  static const TextStyle stepIndicator = TextStyle(
    fontFamily: 'SF Pro Text',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: lightPurple,
    letterSpacing: 1.5,
  );
  
  static const TextStyle navLabel = TextStyle(
    fontFamily: 'SF Pro Text',
    fontSize: 11,
    fontWeight: FontWeight.normal,
  );
  
  // Theme Data
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: white,
    fontFamily: 'SF Pro Text',
    colorScheme: ColorScheme.light(
      primary: primaryPurple,
      secondary: lightPurple,
      surface: white,
      error: coralPink,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: darkText),
      titleTextStyle: heading3,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 56),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusRound),
        ),
        textStyle: buttonText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryPurple,
        side: const BorderSide(color: primaryPurple, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusRound),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: borderColor, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: borderColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: primaryPurple, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
        borderSide: const BorderSide(color: coralPink, width: 1.5),
      ),
      hintStyle: bodyText.copyWith(color: lightGray),
    ),
    cardTheme: CardThemeData(
      color: white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLarge),
      ),
    ),
  );
}
