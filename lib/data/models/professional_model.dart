class Professional {
  final String id;
  final String name;
  final String profession;
  final String category;
  final String avatarUrl;
  final String? profileImageUrl;
  final double rating;
  final int reviewCount;
  final String bio;
  final String about;
  final List<String> skills;
  final int experienceYears;
  final double hourlyRate;
  final bool isVerified;
  final bool isAvailable;
  final bool phoneVerified;
  final bool isProfessional;
  final DateTime? createdAt;
  final List<PortfolioItem> portfolio;
  final List<Review> reviews;
  final List<WorkHistory> workHistory;

  Professional({
    required this.id,
    required this.name,
    required this.profession,
    required this.category,
    required this.avatarUrl,
    this.profileImageUrl,
    required this.rating,
    required this.reviewCount,
    required this.bio,
    required this.about,
    required this.skills,
    required this.experienceYears,
    required this.hourlyRate,
    this.isVerified = false,
    this.isAvailable = true,
    this.phoneVerified = false,
    this.isProfessional = true,
    this.createdAt,
    this.portfolio = const [],
    this.reviews = const [],
    this.workHistory = const [],
  });

  String get safeName => name.trim().isEmpty ? 'Unknown User' : name.trim();

  String get safeProfession => profession.trim().isEmpty ? 'Not set' : profession.trim();

  String get safeAvatarUrl => (profileImageUrl ?? avatarUrl).trim().isEmpty
      ? 'https://via.placeholder.com/200'
      : (profileImageUrl ?? avatarUrl).trim();
}

class PortfolioItem {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final DateTime date;

  PortfolioItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.date,
  });
}

class Review {
  final String id;
  final String clientName;
  final String clientAvatar;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.clientName,
    required this.clientAvatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class WorkHistory {
  final String id;
  final String title;
  final String clientName;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCompleted;

  WorkHistory({
    required this.id,
    required this.title,
    required this.clientName,
    required this.description,
    required this.startDate,
    this.endDate,
    this.isCompleted = true,
  });
}

class HireRequest {
  final String id;
  final Professional professional;
  final DateTime hireDate;
  final String message;
  final String status; // pending, confirmed, completed, cancelled
  final DateTime createdAt;

  HireRequest({
    required this.id,
    required this.professional,
    required this.hireDate,
    required this.message,
    required this.status,
    required this.createdAt,
  });
}

class Category {
  final String id;
  final String name;
  final String icon;
  final int count;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.count,
  });
}
