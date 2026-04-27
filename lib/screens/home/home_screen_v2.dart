import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_colors_v2.dart';
import '../../core/theme/pro_theme_v2.dart';
import '../../core/utils/screen_utils.dart';
import '../../core/services/user_profile_service.dart';
import '../activity/activity_screen.dart';
import '../../data/models/models.dart';
import '../../data/models/user_profile.dart';
import '../../widgets/premium_widgets.dart';

class HomeScreenV2 extends StatefulWidget {
  const HomeScreenV2({super.key});

  @override
  State<HomeScreenV2> createState() => _HomeScreenV2State();
}

class _HomeScreenV2State extends State<HomeScreenV2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _profileService = UserProfileService();

  String _selectedCategory = 'all';
  String _searchQuery = '';
  String _userName = 'User';
  bool _isLoading = true;
  List<Professional> _professionals = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      _selectedCategory = 'all';
      _loadProfessionals();
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await _profileService.seedDummyProfessionalsIfEmpty();
    await _loadCurrentUser();
    await _loadProfessionals();
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _loadCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _userName = 'User';
      return;
    }

    final profile = await _profileService.ensureProfile(
      currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
    );
    _userName = profile.name.trim().isEmpty ? 'User' : profile.name.trim();
  }

  Future<void> _loadProfessionals() async {
    final profiles = await _profileService.searchProfessionals(_searchQuery);
    final type = _tabController.index == 0
        ? ProfessionalType.trade
        : ProfessionalType.freelancer;

    _professionals = profiles
        .map(_mapProfileToProfessional)
        .where((pro) => pro.type == type)
        .toList();

    if (_selectedCategory != 'all') {
      _professionals = _professionals
          .where((p) => p.category == _selectedCategory)
          .toList();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Professional _mapProfileToProfessional(UserProfile profile) {
    final data = profile.professionalData ?? {};
    final skills = (data['skills'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final experienceLevel = (data['experienceLevel'] as String?) ?? 'Beginner';
    final typeString = (data['type'] as String?) ?? 'freelancer';
    final proType = typeString == 'trade'
        ? ProfessionalType.trade
        : ProfessionalType.freelancer;

    return Professional(
      id: profile.uid,
      name: profile.name,
      profession: data['title'] as String? ?? 'Professional',
      category: data['category'] as String? ?? 'General',
      type: proType,
      avatarUrl: profile.profileImageUrl ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (data['reviewCount'] as num?)?.toInt() ?? 0,
      tagline: profile.bio,
      about: profile.bio,
      skills: skills,
      experienceYears: _experienceFromLevel(experienceLevel),
      hourlyRate: (data['hourlyRate'] as num?)?.toDouble() ?? 0,
      currency: profile.currency,
      location: profile.companyName ?? 'Remote',
      memberSince: DateTime.now(),
    );
  }

  int _experienceFromLevel(String level) {
    switch (level) {
      case 'Expert':
        return 7;
      case 'Intermediate':
        return 3;
      default:
        return 1;
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
    final screen = _getScreenInfo(context);
    
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.primary,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: _buildHeader(context, screen),
              ),

              // Search
              SliverToBoxAdapter(
                child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screen.horizontalPadding,
                        vertical: ProTheme.spaceSm,
                      ),
                      child: PremiumSearchBar(
                        controller: _searchController,
                        hintText: _tabController.index == 0
                            ? 'Find plumbers, electricians...'
                            : 'Find developers, designers...',
                        onFilterTap: null,
                        onChanged: (query) {
                          _searchQuery = query.trim();
                          _loadProfessionals();
                        },
                      ),
                    ),
                  ),

                  // Tab Bar
                  SliverToBoxAdapter(
                    child: _buildTabBar(context, screen),
                  ),

                  // Section Title
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        screen.horizontalPadding,
                        ProTheme.spaceLg,
                        screen.horizontalPadding,
                        ProTheme.spaceMd,
                      ),
                      child: SectionHeader(
                        title: _tabController.index == 0
                            ? 'Nearby Professionals'
                            : 'Top Freelancers',
                        actionText: 'View All',
                        onAction: () {},
                      ),
                    ),
                  ),

                  // Grid
                  _buildProfessionalsGrid(context, screen),

                  // Bottom Padding
                  SliverToBoxAdapter(
                    child: SizedBox(height: screen.safeBottom + 80),
                  ),
                ],
              ),
            ),
          ),
        );
  }

  Widget _buildHeader(BuildContext context, ScreenInfo screen) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        screen.horizontalPadding,
        ProTheme.spaceMd,
        screen.horizontalPadding,
        ProTheme.spaceSm,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: screen.isMobile ? 48 : 56,
            height: screen.isMobile ? 48 : 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: AppColors.primaryGlow(0.3),
            ),
            child: const Center(
              child: Icon(Icons.handshake_rounded, color: Colors.white, size: 26),
            ),
          ),
          SizedBox(width: screen.spacing(12)),
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $_userName!',
                  style: TextStyle(
                    fontSize: screen.fontSize(20),
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Find the perfect professional',
                  style: TextStyle(
                    fontSize: screen.fontSize(14),
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          // Actions
          _buildIconButton(
            icon: Icons.notifications_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ActivityScreen()),
              );
            },
            isDark: isDark,
            screen: screen,
            hasBadge: true,
          ),
          SizedBox(width: screen.spacing(8)),
          _buildIconButton(
            icon: Icons.bookmark_outline,
            onTap: () {},
            isDark: isDark,
            screen: screen,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    required ScreenInfo screen,
    bool hasBadge = false,
  }) {
    return Stack(
      children: [
        Material(
          color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: screen.isMobile ? 44 : 48,
              height: screen.isMobile ? 44 : 48,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                size: screen.iconSize(22),
              ),
            ),
          ),
        ),
        if (hasBadge)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context, ScreenInfo screen) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screen.horizontalPadding,
        vertical: ProTheme.spaceMd,
      ),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(ProTheme.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: _tabController.index == 0
              ? AppColors.tradeGradient
              : AppColors.freelanceGradient,
          borderRadius: BorderRadius.circular(ProTheme.radiusSm),
          boxShadow: [
            BoxShadow(
              color: (_tabController.index == 0
                      ? AppColors.trade
                      : AppColors.freelance)
                  .withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor:
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        labelStyle: TextStyle(
          fontSize: screen.fontSize(14),
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: screen.fontSize(14),
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.build_outlined, size: screen.iconSize(18)),
                const SizedBox(width: 8),
                const Text('Trade'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.laptop_mac_outlined, size: screen.iconSize(18)),
                const SizedBox(width: 8),
                const Text('Freelance'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalsGrid(BuildContext context, ScreenInfo screen) {
    if (_isLoading) {
      return SliverAdaptiveGrid(
        itemCount: 6,
        itemBuilder: (context, index) => const ShimmerProfessionalCard(),
        minCrossAxisCount: 2,
        maxCrossAxisCount: 4,
        childAspectRatio: 0.72,
        mainAxisSpacing: screen.spacing(12),
        crossAxisSpacing: screen.spacing(12),
        minChildWidth: 160,
      );
    }

    if (_professionals.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            screen.horizontalPadding,
            24,
            screen.horizontalPadding,
            screen.safeBottom + 120,
          ),
          child: EmptyState(
            icon: Icons.search_off_rounded,
            title: 'No results found',
            subtitle: 'Try searching by name or skills',
            actionText: 'Clear Search',
            onAction: () {
              _searchController.clear();
              _searchQuery = '';
              _loadProfessionals();
            },
          ),
        ),
      );
    }

    return SliverAdaptiveGrid(
      itemCount: _professionals.length,
      itemBuilder: (context, index) {
        final pro = _professionals[index];
        return ProfessionalCard(
          professional: pro,
          onTap: () => _navigateToProfile(pro),
        );
      },
      minCrossAxisCount: 2,
      maxCrossAxisCount: 4,
      childAspectRatio: 0.72,
      mainAxisSpacing: screen.spacing(12),
      crossAxisSpacing: screen.spacing(12),
      minChildWidth: 160,
    );
  }

  void _navigateToProfile(Professional professional) {
    Navigator.pushNamed(
      context,
      '/profile',
      arguments: professional,
    );
  }

}
