import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive_utils.dart';
import '../../providers/app_provider.dart';
import '../../data/models/professional_model.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/shimmer_widgets.dart';

class ProfessionalProfileScreen extends StatefulWidget {
  const ProfessionalProfileScreen({super.key});

  @override
  State<ProfessionalProfileScreen> createState() =>
      _ProfessionalProfileScreenState();
}

class _ProfessionalProfileScreenState extends State<ProfessionalProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final showTitle = _scrollController.offset > 200;
    if (showTitle != _showAppBarTitle) {
      setState(() => _showAppBarTitle = showTitle);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final professional = provider.selectedProfessional;

        if (professional == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Professional not found')),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar
              _buildSliverAppBar(professional, isDark),

              // Profile Header
              SliverToBoxAdapter(
                child: _buildProfileHeader(professional, context, isDark),
              ),

              // Quick Stats
              SliverToBoxAdapter(
                child: _buildQuickStats(professional, isDark),
              ),

              // Tab Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(text: 'About'),
                      Tab(text: 'Portfolio'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                  isDark
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
                ),
              ),

              // Tab Content
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAboutTab(professional, isDark),
                    _buildPortfolioTab(professional, isDark),
                    _buildReviewsTab(professional, isDark),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(professional, isDark),
        );
      },
    );
  }

  Widget _buildSliverAppBar(Professional professional, bool isDark) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isDark ? Colors.black : Colors.white).withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isDark ? Colors.black : Colors.white).withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              size: 18,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isDark ? Colors.black : Colors.white).withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.share_rounded,
              size: 18,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
        ),
      ],
      title: AnimatedOpacity(
        opacity: _showAppBarTitle ? 1 : 0,
        duration: AppConstants.fastAnimation,
        child: Text(
          professional.name,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withOpacity(0.2),
                isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
      Professional professional, BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.all(Responsive.getHorizontalPadding()),
      child: Column(
        children: [
          // Avatar
          Hero(
            tag: 'avatar_${professional.id}',
            child: Container(
              width: Responsive.isTablet ? 140 : 110,
              height: Responsive.isTablet ? 140 : 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  professional.avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.primary.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      size: 56,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name and Verified Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                professional.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              if (professional.isVerified) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.verified,
                  color: AppColors.primary,
                  size: 24,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),

          // Profession Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),
            child: Text(
              professional.profession,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RatingStars(rating: professional.rating),
              const SizedBox(width: 8),
              Text(
                '(${professional.reviewCount} reviews)',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(Professional professional, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.getHorizontalPadding(),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : Colors.grey).withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                '${professional.experienceYears}+',
                'Years Exp.',
                Icons.work_history_rounded,
                isDark,
              ),
            ),
            Container(
              height: 40,
              width: 1,
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            ),
            Expanded(
              child: _buildStatItem(
                '\$${professional.hourlyRate}',
                'Per Hour',
                Icons.attach_money_rounded,
                isDark,
              ),
            ),
            Container(
              height: 40,
              width: 1,
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            ),
            Expanded(
              child: _buildStatItem(
                '${professional.reviewCount}',
                'Reviews',
                Icons.rate_review_rounded,
                isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String value, String label, IconData icon, bool isDark) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutTab(Professional professional, bool isDark) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.getHorizontalPadding()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Section
          Text(
            'About',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            professional.about,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 24),

          // Skills Section
          Text(
            'Skills',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                professional.skills.map((skill) => SkillChip(label: skill)).toList(),
          ),
          const SizedBox(height: 24),

          // Work History Section
          Text(
            'Work History',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          ...professional.workHistory.map((work) => _buildWorkHistoryItem(work, isDark)),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildWorkHistoryItem(WorkHistory work, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: work.isCompleted
                    ? AppColors.success
                    : AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    work.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    work.clientName,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    work.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (work.isCompleted)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioTab(Professional professional, bool isDark) {
    return GridView.builder(
      padding: EdgeInsets.all(Responsive.getHorizontalPadding()),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isTablet ? 3 : 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: professional.portfolio.length,
      itemBuilder: (context, index) {
        final item = professional.portfolio[index];
        return _buildPortfolioItem(item, isDark);
      },
    );
  }

  Widget _buildPortfolioItem(PortfolioItem item, bool isDark) {
    return GestureDetector(
      onTap: () => _showPortfolioDialog(item),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.primary.withOpacity(0.2),
                  child: Icon(
                    Icons.image,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPortfolioDialog(PortfolioItem item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.cardDark
                : AppColors.cardLight,
            borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsTab(Professional professional, bool isDark) {
    return ListView.builder(
      padding: EdgeInsets.all(Responsive.getHorizontalPadding()),
      itemCount: professional.reviews.length,
      itemBuilder: (context, index) {
        final review = professional.reviews[index];
        return _buildReviewItem(review, isDark);
      },
    );
  }

  Widget _buildReviewItem(Review review, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(review.clientAvatar),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.clientName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RatingStars(
                        rating: review.rating,
                        size: 14,
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDate(review.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays < 1) return 'Today';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return '${(diff.inDays / 30).floor()}mo ago';
  }

  Widget _buildBottomBar(Professional professional, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hourly Rate',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${professional.hourlyRate}/hr',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: GradientButton(
                text: 'Hire Now',
                icon: Icons.handshake_rounded,
                onPressed: () {
                  Navigator.pushNamed(context, '/hire');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _SliverTabBarDelegate(this.tabBar, this.backgroundColor);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
