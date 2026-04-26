import 'package:flutter/material.dart';
import '../../core/theme/app_colors_v2.dart';
import '../../core/theme/pro_theme_v2.dart';
import '../../core/utils/screen_utils.dart';
import '../../data/models/models.dart';
import '../../data/mock/sample_data.dart';
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

  String _selectedCategory = 'all';
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
    await Future.delayed(const Duration(milliseconds: 800));
    _loadProfessionals();
    setState(() => _isLoading = false);
  }

  void _loadProfessionals() {
    final type = _tabController.index == 0
        ? ProfessionalType.trade
        : ProfessionalType.freelancer;
    
    _professionals = MockData.getByType(type);
    
    if (_selectedCategory != 'all') {
      _professionals = _professionals
          .where((p) => p.category == _selectedCategory)
          .toList();
    }
  }

  List<Category> get _currentCategories {
    return _tabController.index == 0
        ? TradeCategories.all
        : FreelancerCategories.all;
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
                        onFilterTap: () => _showFilterSheet(context),
                        onChanged: (query) {
                          // Search logic
                          setState(() {});
                        },
                      ),
                    ),
                  ),

                  // Tab Bar
                  SliverToBoxAdapter(
                    child: _buildTabBar(context, screen),
                  ),

                  // Categories
                  SliverToBoxAdapter(
                    child: _buildCategories(context, screen),
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
              child: Text(
                '👋',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          SizedBox(width: screen.spacing(12)),
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, John!',
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
            onTap: () {},
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

  Widget _buildCategories(BuildContext context, ScreenInfo screen) {
    final categories = _currentCategories;

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screen.horizontalPadding),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: _buildAllCategoryChip(context, screen),
            );
          }

          final category = categories[index - 1];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CategoryChip(
              category: category,
              isSelected: _selectedCategory == category.id,
              onTap: () {
                setState(() {
                  _selectedCategory = category.id;
                  _loadProfessionals();
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAllCategoryChip(BuildContext context, ScreenInfo screen) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedCategory == 'all';
    final isTrade = _tabController.index == 0;
    final accentColor = isTrade ? AppColors.trade : AppColors.freelance;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = 'all';
          _loadProfessionals();
        });
      },
      child: AnimatedContainer(
        duration: ProTheme.normalDuration,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? (isTrade ? AppColors.tradeGradient : AppColors.freelanceGradient)
              : null,
          color: isSelected
              ? null
              : (isDark ? AppColors.cardDark : AppColors.surfaceLight),
          borderRadius: BorderRadius.circular(ProTheme.radiusFull),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.grid_view_rounded,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : (isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight),
            ),
            const SizedBox(width: 8),
            Text(
              'All',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
              ),
            ),
          ],
        ),
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
      return SliverFillRemaining(
        child: EmptyState(
          icon: Icons.search_off_rounded,
          title: 'No Professionals Found',
          subtitle: 'Try selecting a different category',
          actionText: 'View All',
          onAction: () {
            setState(() {
              _selectedCategory = 'all';
              _loadProfessionals();
            });
          },
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

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterSheet(context),
    );
  }

  Widget _buildFilterSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ProTheme.radiusXl),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Filter',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 24),
          // Filter options go here
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rating',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (final rating in [4.5, 4.0, 3.5, 3.0])
                        FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, size: 14, color: AppColors.starFilled),
                              const SizedBox(width: 4),
                              Text('$rating+'),
                            ],
                          ),
                          selected: false,
                          onSelected: (_) {},
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Availability',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: [
                      FilterChip(
                        label: const Text('Available Now'),
                        selected: false,
                        onSelected: (_) {},
                      ),
                      FilterChip(
                        label: const Text('Top Rated'),
                        selected: false,
                        onSelected: (_) {},
                      ),
                      FilterChip(
                        label: const Text('Verified'),
                        selected: false,
                        onSelected: (_) {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              16,
              24,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            child: PremiumButton(
              text: 'Apply Filters',
              onPressed: () => Navigator.pop(context),
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
