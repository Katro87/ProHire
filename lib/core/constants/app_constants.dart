class AppConstants {
  // App Info
  static const String appName = 'ProjectMad';
  static const String appTagline = 'Find the Right Professional';
  
  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration splashDuration = Duration(seconds: 2);
  
  // Spacing (8px grid system)
  static const double spacingXxs = 4;
  static const double spacingXs = 8;
  static const double spacingSm = 12;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;
  
  // Border Radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusXxl = 24;
  static const double radiusFull = 999;
  
  // Icon Sizes
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;
  
  // Avatar Sizes
  static const double avatarSm = 32;
  static const double avatarMd = 48;
  static const double avatarLg = 64;
  static const double avatarXl = 96;
  static const double avatarXxl = 128;
  
  // Card Dimensions
  static const double cardElevation = 8;
  static const double cardShadowBlur = 20;
  
  // Font Sizes
  static const double fontXs = 11;
  static const double fontSm = 13;
  static const double fontMd = 15;
  static const double fontLg = 17;
  static const double fontXl = 20;
  static const double fontXxl = 24;
  static const double fontDisplay = 32;
  
  // Onboarding
  static const int onboardingPageCount = 3;
  
  // Categories
  static const List<String> professionalCategories = [
    'All',
    'Developers',
    'Designers',
    'Electricians',
    'Plumbers',
    'Tutors',
    'Photographers',
    'Writers',
    'Marketers',
    'Consultants',
    'Fitness',
  ];
  
  // Placeholder Images
  static const String avatarPlaceholder = 'https://ui-avatars.com/api/?name=User&background=6366F1&color=fff&size=200';
  static const String portfolioPlaceholder = 'https://picsum.photos/400/300';
}

// Status enum for hire history
enum HireStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

extension HireStatusExtension on HireStatus {
  String get displayName {
    switch (this) {
      case HireStatus.pending:
        return 'Pending';
      case HireStatus.confirmed:
        return 'Confirmed';
      case HireStatus.inProgress:
        return 'In Progress';
      case HireStatus.completed:
        return 'Completed';
      case HireStatus.cancelled:
        return 'Cancelled';
    }
  }
  
  String get color {
    switch (this) {
      case HireStatus.pending:
        return 'warning';
      case HireStatus.confirmed:
        return 'info';
      case HireStatus.inProgress:
        return 'primary';
      case HireStatus.completed:
        return 'success';
      case HireStatus.cancelled:
        return 'error';
    }
  }
}
