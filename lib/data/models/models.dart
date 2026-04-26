/// Professional Type - Trade vs Freelancer
enum ProfessionalType {
  trade,      // Plumber, Electrician, Carpenter, etc.
  freelancer, // Developer, Designer, Writer, etc.
}

/// Professional Model
class Professional {
  final String id;
  final String name;
  final String profession;
  final String category;
  final ProfessionalType type;
  final String avatarUrl;
  final String? coverUrl;
  final double rating;
  final int reviewCount;
  final int completedJobs;
  final String tagline;
  final String about;
  final List<String> skills;
  final int experienceYears;
  final double hourlyRate;
  final double? projectRate;
  final bool isVerified;
  final bool isAvailable;
  final bool isTopRated;
  final String location;
  final double? distance;
  final List<String> languages;
  final List<PortfolioItem> portfolio;
  final List<Review> reviews;
  final List<WorkHistory> workHistory;
  final List<String> certifications;
  final Map<String, dynamic>? availability;
  final DateTime memberSince;

  const Professional({
    required this.id,
    required this.name,
    required this.profession,
    required this.category,
    required this.type,
    required this.avatarUrl,
    this.coverUrl,
    required this.rating,
    required this.reviewCount,
    this.completedJobs = 0,
    required this.tagline,
    required this.about,
    required this.skills,
    required this.experienceYears,
    required this.hourlyRate,
    this.projectRate,
    this.isVerified = false,
    this.isAvailable = true,
    this.isTopRated = false,
    required this.location,
    this.distance,
    this.languages = const ['English'],
    this.portfolio = const [],
    this.reviews = const [],
    this.workHistory = const [],
    this.certifications = const [],
    this.availability,
    required this.memberSince,
  });

  /// Whether this is a trade professional
  bool get isTrade => type == ProfessionalType.trade;

  /// Whether this is a freelancer
  bool get isFreelancer => type == ProfessionalType.freelancer;

  /// Display rate string
  String get rateDisplay {
    if (isTrade) {
      return '\$${hourlyRate.toStringAsFixed(0)}/hr';
    }
    if (projectRate != null) {
      return 'From \$${projectRate!.toStringAsFixed(0)}';
    }
    return '\$${hourlyRate.toStringAsFixed(0)}/hr';
  }
}

/// Portfolio Item
class PortfolioItem {
  final String id;
  final String title;
  final String imageUrl;
  final String? description;
  final List<String> tags;
  final DateTime date;
  final String? projectUrl;

  const PortfolioItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.description,
    this.tags = const [],
    required this.date,
    this.projectUrl,
  });
}

/// Review
class Review {
  final String id;
  final String clientName;
  final String clientAvatar;
  final double rating;
  final String comment;
  final DateTime date;
  final String? projectTitle;
  final List<String>? images;

  const Review({
    required this.id,
    required this.clientName,
    required this.clientAvatar,
    required this.rating,
    required this.comment,
    required this.date,
    this.projectTitle,
    this.images,
  });
}

/// Work History
class WorkHistory {
  final String id;
  final String title;
  final String clientName;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCompleted;
  final double? earnings;

  const WorkHistory({
    required this.id,
    required this.title,
    required this.clientName,
    required this.description,
    required this.startDate,
    this.endDate,
    this.isCompleted = true,
    this.earnings,
  });
}

/// Hire/Booking Request
class HireRequest {
  final String id;
  final Professional professional;
  final DateTime requestDate;
  final DateTime? scheduledDate;
  final String? timeSlot;
  final String description;
  final String status; // pending, confirmed, in_progress, completed, cancelled
  final double? quotedPrice;
  final String? address;
  final String? notes;

  const HireRequest({
    required this.id,
    required this.professional,
    required this.requestDate,
    this.scheduledDate,
    this.timeSlot,
    required this.description,
    required this.status,
    this.quotedPrice,
    this.address,
    this.notes,
  });

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
}

/// Category
class Category {
  final String id;
  final String name;
  final String icon;
  final ProfessionalType type;
  final int count;
  final String? description;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    this.count = 0,
    this.description,
  });
}

/// Trade Categories
class TradeCategories {
  static const List<Category> all = [
    Category(id: 'plumber', name: 'Plumber', icon: '🔧', type: ProfessionalType.trade, count: 234),
    Category(id: 'electrician', name: 'Electrician', icon: '⚡', type: ProfessionalType.trade, count: 189),
    Category(id: 'carpenter', name: 'Carpenter', icon: '🪚', type: ProfessionalType.trade, count: 156),
    Category(id: 'painter', name: 'Painter', icon: '🎨', type: ProfessionalType.trade, count: 203),
    Category(id: 'hvac', name: 'HVAC Tech', icon: '❄️', type: ProfessionalType.trade, count: 87),
    Category(id: 'roofer', name: 'Roofer', icon: '🏠', type: ProfessionalType.trade, count: 92),
    Category(id: 'mason', name: 'Mason', icon: '🧱', type: ProfessionalType.trade, count: 78),
    Category(id: 'welder', name: 'Welder', icon: '🔥', type: ProfessionalType.trade, count: 65),
    Category(id: 'landscaper', name: 'Landscaper', icon: '🌳', type: ProfessionalType.trade, count: 143),
    Category(id: 'cleaner', name: 'Cleaner', icon: '🧹', type: ProfessionalType.trade, count: 312),
    Category(id: 'mover', name: 'Mover', icon: '📦', type: ProfessionalType.trade, count: 98),
    Category(id: 'handyman', name: 'Handyman', icon: '🛠️', type: ProfessionalType.trade, count: 267),
  ];
}

/// Freelancer Categories
class FreelancerCategories {
  static const List<Category> all = [
    Category(id: 'developer', name: 'Developer', icon: '💻', type: ProfessionalType.freelancer, count: 1543),
    Category(id: 'designer', name: 'Designer', icon: '🎨', type: ProfessionalType.freelancer, count: 1287),
    Category(id: 'writer', name: 'Writer', icon: '✍️', type: ProfessionalType.freelancer, count: 892),
    Category(id: 'marketer', name: 'Marketer', icon: '📈', type: ProfessionalType.freelancer, count: 654),
    Category(id: 'video', name: 'Video Editor', icon: '🎬', type: ProfessionalType.freelancer, count: 432),
    Category(id: 'photo', name: 'Photographer', icon: '📸', type: ProfessionalType.freelancer, count: 567),
    Category(id: 'music', name: 'Musician', icon: '🎵', type: ProfessionalType.freelancer, count: 234),
    Category(id: 'voice', name: 'Voice Artist', icon: '🎙️', type: ProfessionalType.freelancer, count: 187),
    Category(id: 'translator', name: 'Translator', icon: '🌐', type: ProfessionalType.freelancer, count: 345),
    Category(id: 'consultant', name: 'Consultant', icon: '💼', type: ProfessionalType.freelancer, count: 423),
    Category(id: 'accountant', name: 'Accountant', icon: '📊', type: ProfessionalType.freelancer, count: 298),
    Category(id: 'tutor', name: 'Tutor', icon: '📚', type: ProfessionalType.freelancer, count: 534),
  ];
}
