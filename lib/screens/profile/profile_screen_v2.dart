import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors_v2.dart';
import '../../core/theme/pro_theme_v2.dart';
import '../../core/utils/screen_utils.dart';
import '../../data/models/models.dart';
import '../../widgets/premium_widgets.dart';

class ProfileScreenV2 extends StatefulWidget {
  final Professional? professional;

  const ProfileScreenV2({super.key, this.professional});

  @override
  State<ProfileScreenV2> createState() => _ProfileScreenV2State();
}

class _ProfileScreenV2State extends State<ProfileScreenV2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;
  bool _isFavorite = false;
  bool _favoriteLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
    _loadFavoriteState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  Future<void> _loadFavoriteState() async {
    final pro = widget.professional;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (pro == null || currentUser == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('favorites')
        .doc('${currentUser.uid}_${pro.id}')
        .get();

    if (!mounted) return;
    setState(() => _isFavorite = doc.exists);
  }

  Future<void> _toggleFavorite() async {
    final pro = widget.professional;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (pro == null || currentUser == null || _favoriteLoading) return;

    setState(() => _favoriteLoading = true);
    final docRef = FirebaseFirestore.instance
        .collection('favorites')
        .doc('${currentUser.uid}_${pro.id}');

    try {
      if (_isFavorite) {
        await docRef.delete();
      } else {
        await docRef.set({
          'userId': currentUser.uid,
          'targetId': pro.id,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;
      setState(() {
        _isFavorite = !_isFavorite;
        _favoriteLoading = false;
      });

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          ),
        );
    } catch (_) {
      if (!mounted) return;
      setState(() => _favoriteLoading = false);
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: const Text('Unable to update favorite right now'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          ),
        );
    }
  }

  ScreenInfo _getScreenInfo(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    
    DeviceType deviceType;
    if (width < 360) {
      deviceType = DeviceType.mobileSmall;
    } else if (width < 415) {
      deviceType = DeviceType.mobile;
    } else if (width < 600) {
      deviceType = DeviceType.mobileLarge;
    } else if (width < 900) {
      deviceType = DeviceType.tablet;
    } else if (width < 1200) {
      deviceType = DeviceType.tabletLarge;
    } else {
      deviceType = DeviceType.desktop;
    }
    
    return ScreenInfo(
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
  }

  @override
  Widget build(BuildContext context) {
    final pro = widget.professional;
    if (pro == null) {
      return const Scaffold(
        body: Center(child: Text('Professional not found')),
      );
    }

    final screen = _getScreenInfo(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = pro.isTrade ? AppColors.trade : AppColors.freelance;
    final headerHeight = screen.isMobile ? 280.0 : 320.0;
    final showAppBarTitle = _scrollOffset > headerHeight - 100;

    return Scaffold(
      body: Stack(
        children: [
          // Content
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header Image with Profile
              SliverToBoxAdapter(
                child: _buildHeader(context, screen, pro, accentColor),
              ),

              // Info Cards
              SliverToBoxAdapter(
                child: _buildInfoCards(context, screen, pro, accentColor),
              ),

              // Tab Bar
              SliverPersistentHeader(
                    pinned: true,
                    delegate: _TabBarDelegate(
                      tabController: _tabController,
                      isDark: isDark,
                      accentColor: accentColor,
                    ),
                  ),

                  // Tab Content
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildTabContent(context, screen, pro),
                  ),
                ],
              ),

              // App Bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildAppBar(context, screen, showAppBarTitle, pro.name),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(context, screen, pro, accentColor),
        );
  }

  Widget _buildAppBar(
    BuildContext context,
    ScreenInfo screen,
    bool showTitle,
    String title,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: showTitle ? 10 : 0,
          sigmaY: showTitle ? 10 : 0,
        ),
        child: AnimatedContainer(
          duration: ProTheme.normalDuration,
          color: showTitle
              ? (isDark
                  ? AppColors.surfaceDark.withValues(alpha: 0.9)
                  : AppColors.surfaceLight.withValues(alpha: 0.9))
              : Colors.transparent,
          padding: EdgeInsets.only(top: screen.safeTop),
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                const SizedBox(width: 8),
                _buildCircleButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.pop(context),
                  isDark: isDark,
                  elevated: !showTitle,
                  tooltip: 'Back',
                ),
                const Spacer(),
                AnimatedOpacity(
                  duration: ProTheme.normalDuration,
                  opacity: showTitle ? 1 : 0,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                ),
                const Spacer(),
                _buildCircleButton(
                  icon: Icons.share_outlined,
                  onTap: () {},
                  isDark: isDark,
                  elevated: !showTitle,
                  tooltip: 'Share profile',
                ),
                const SizedBox(width: 8),
                _buildCircleButton(
                  icon: _isFavorite ? Icons.bookmark_rounded : Icons.bookmark_outline,
                  onTap: _toggleFavorite,
                  isDark: isDark,
                  elevated: !showTitle,
                  tooltip: 'Add to favorites',
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    bool elevated = false,
    String? tooltip,
  }) {
    final button = GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: elevated
              ? Colors.black.withValues(alpha: 0.3)
              : (isDark ? AppColors.cardDark : AppColors.surfaceLight),
          shape: BoxShape.circle,
          border: elevated
              ? null
              : Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
        ),
        child: Icon(
          icon,
          color: elevated
              ? Colors.white
              : (isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight),
          size: 20,
        ),
      ),
    );

    return tooltip == null ? button : Tooltip(message: tooltip, child: button);
  }

  Widget _buildHeader(
    BuildContext context,
    ScreenInfo screen,
    Professional pro,
    Color accentColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerHeight = screen.isMobile ? 280.0 : 320.0;

    return SizedBox(
      height: headerHeight,
      child: Stack(
        children: [
          // Background Gradient
          Container(
            height: headerHeight * 0.6,
            decoration: BoxDecoration(
              gradient: pro.isTrade
                  ? AppColors.tradeGradient
                  : AppColors.freelanceGradient,
            ),
          ),

          // Cover Image (if available)
          if (pro.coverUrl != null)
            Positioned.fill(
              bottom: headerHeight * 0.4,
              child: Image.network(
                pro.coverUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),

          // Gradient Overlay
          Positioned.fill(
            bottom: headerHeight * 0.4,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    accentColor.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),

          // Profile Info
          Positioned(
            left: screen.horizontalPadding,
            right: screen.horizontalPadding,
            bottom: 0,
            child: Column(
              children: [
                // Avatar
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    shape: BoxShape.circle,
                    boxShadow: AppColors.mediumShadow,
                  ),
                  child: CircleAvatar(
                    radius: screen.isMobile ? 50 : 60,
                    backgroundImage: NetworkImage(pro.avatarUrl),
                    backgroundColor: accentColor.withValues(alpha: 0.1),
                  ),
                ),
                const SizedBox(height: 12),
                // Name with badges
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        pro.name,
                        style: TextStyle(
                          fontSize: screen.fontSize(24),
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (pro.isVerified) ...[
                      const SizedBox(width: 6),
                      Icon(
                        Icons.verified,
                        color: AppColors.primary,
                        size: screen.iconSize(22),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                // Profession
                Text(
                  pro.profession,
                  style: TextStyle(
                    fontSize: screen.fontSize(15),
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                // Location
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      pro.location,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards(
    BuildContext context,
    ScreenInfo screen,
    Professional pro,
    Color accentColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.all(screen.horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context: context,
              icon: Icons.star_rounded,
              iconColor: AppColors.starFilled,
              value: pro.rating.toStringAsFixed(1),
              label: '${pro.reviewCount} reviews',
              isDark: isDark,
            ),
          ),
          SizedBox(width: screen.spacing(12)),
          Expanded(
            child: _buildStatCard(
              context: context,
              icon: Icons.work_outline_rounded,
              iconColor: accentColor,
              value: '${pro.completedJobs}',
              label: 'Jobs done',
              isDark: isDark,
            ),
          ),
          SizedBox(width: screen.spacing(12)),
          Expanded(
            child: _buildStatCard(
              context: context,
              icon: Icons.access_time_rounded,
              iconColor: AppColors.secondary,
              value: '${pro.experienceYears}y',
              label: 'Experience',
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(ProTheme.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    ScreenInfo screen,
    Professional pro,
  ) {
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildAboutTab(context, screen, pro),
        _buildPortfolioTab(context, screen, pro),
        _buildReviewsTab(context, screen, pro),
      ],
    );
  }

  Widget _buildAboutTab(
    BuildContext context,
    ScreenInfo screen,
    Professional pro,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screen.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tagline
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (pro.isTrade ? AppColors.trade : AppColors.freelance)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ProTheme.radiusMd),
            ),
            child: Text(
              '"${pro.tagline}"',
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: pro.isTrade ? AppColors.trade : AppColors.freelance,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // About
          Text(
            'About',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            pro.about,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 24),

          // Skills
          Text(
            'Skills',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pro.skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Certifications
          if (pro.certifications.isNotEmpty) ...[
            Text(
              'Certifications',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            ...pro.certifications.map((cert) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        size: 18,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          cert,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildPortfolioTab(
    BuildContext context,
    ScreenInfo screen,
    Professional pro,
  ) {
    if (pro.portfolio.isEmpty) {
      return EmptyState(
        icon: Icons.photo_library_outlined,
        title: 'No Portfolio Yet',
        subtitle: 'This professional hasn\'t added any work samples yet.',
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(screen.horizontalPadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screen.gridColumns(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: pro.portfolio.length,
      itemBuilder: (context, index) {
        final item = pro.portfolio[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(ProTheme.radiusMd),
          child: Image.network(
            item.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.dividerLight,
              child: const Icon(Icons.image_not_supported),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab(
    BuildContext context,
    ScreenInfo screen,
    Professional pro,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (pro.reviews.isEmpty) {
      return EmptyState(
        icon: Icons.rate_review_outlined,
        title: 'No Reviews Yet',
        subtitle: 'Be the first to leave a review!',
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(screen.horizontalPadding),
      itemCount: pro.reviews.length,
      separatorBuilder: (_, __) => const Divider(height: 32),
      itemBuilder: (context, index) {
        final review = pro.reviews[index];
        return Column(
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
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      if (review.projectTitle != null)
                        Text(
                          review.projectTitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiaryLight,
                          ),
                        ),
                    ],
                  ),
                ),
                RatingStars(rating: review.rating, size: 14),
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
        );
      },
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    ScreenInfo screen,
    Professional pro,
    Color accentColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(
        screen.horizontalPadding,
        16,
        screen.horizontalPadding,
        screen.safeBottom + 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        ),
      ),
      child: Row(
        children: [
          // Price
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pro.rateDisplay,
                style: TextStyle(
                  fontSize: screen.fontSize(22),
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
              Text(
                pro.isTrade ? 'per hour' : 'starting from',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          // Hire Button
          Expanded(
            child: PremiumButton(
              text: pro.isTrade ? 'Book Now' : 'Hire Now',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/hire',
                  arguments: pro,
                );
              },
              gradient: pro.isTrade
                  ? AppColors.tradeGradient
                  : AppColors.freelanceGradient,
              height: 52,
            ),
          ),
        ],
      ),
    );
  }
}

// Tab Bar Delegate
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final bool isDark;
  final Color accentColor;

  _TabBarDelegate({
    required this.tabController,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: TabBar(
        controller: tabController,
        labelColor: accentColor,
        unselectedLabelColor:
            isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
        indicatorColor: accentColor,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'About'),
          Tab(text: 'Portfolio'),
          Tab(text: 'Reviews'),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
