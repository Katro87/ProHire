import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive_utils.dart';
import '../../providers/app_provider.dart';
import '../../data/models/professional_model.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/shimmer_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await context.read<AppProvider>().loadData();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: AppColors.primary,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: _buildHeader(context, isDark),
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.getHorizontalPadding(),
                    vertical: 8,
                  ),
                  child: CustomSearchBar(
                    controller: _searchController,
                    hintText: 'Search professionals, skills...',
                    onFilterTap: () => _showFilterSheet(context),
                    onChanged: (query) {
                      context.read<AppProvider>().searchProfessionals(query);
                    },
                  ),
                ),
              ),

              // Categories
              SliverToBoxAdapter(
                child: _buildCategories(context),
              ),

              // Section Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    Responsive.getHorizontalPadding(),
                    24,
                    Responsive.getHorizontalPadding(),
                    16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Professionals',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Text('View All'),
                        label: const Icon(Icons.arrow_forward_ios, size: 14),
                      ),
                    ],
                  ),
                ),
              ),

              // Professionals Grid
              Consumer<AppProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.getHorizontalPadding(),
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Responsive.getGridColumnCount(),
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => const ShimmerProfessionalCard(),
                          childCount: 6,
                        ),
                      ),
                    );
                  }

                  final professionals = provider.filteredProfessionals;
                  
                  if (professionals.isEmpty) {
                    return SliverFillRemaining(
                      child: EmptyStateWidget(
                        title: 'No Professionals Found',
                        subtitle: 'Try adjusting your search or filters to find what you\'re looking for.',
                        icon: Icons.search_off_rounded,
                        actionLabel: 'Clear Filters',
                        onAction: () {
                          _searchController.clear();
                          provider.filterByCategory('All');
                          provider.searchProfessionals('');
                        },
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.getHorizontalPadding(),
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.getGridColumnCount(),
                        childAspectRatio: _getCardAspectRatio(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final professional = professionals[index];
                          return ProfessionalCard(
                            id: professional.id,
                            name: professional.name,
                            profession: professional.profession,
                            avatarUrl: professional.avatarUrl,
                            rating: professional.rating,
                            reviewCount: professional.reviewCount,
                            bio: professional.bio,
                            isVerified: professional.isVerified,
                            onTap: () => _goToProfile(professional),
                            onHire: () => _goToHire(professional),
                          );
                        },
                        childCount: professionals.length,
                      ),
                    ),
                  );
                },
              ),

              // Bottom spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getCardAspectRatio() {
    if (Responsive.isTablet) return 0.78;
    if (Responsive.screenWidth < 360) return 0.65;
    return 0.72;
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.all(Responsive.getHorizontalPadding()),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back! 👋',
                  style: TextStyle(
                    fontSize: Responsive.sp(14),
                    color: isDark 
                        ? AppColors.textSecondaryDark 
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find Your Professional',
                  style: TextStyle(
                    fontSize: Responsive.sp(24),
                    fontWeight: FontWeight.w800,
                    color: isDark 
                        ? AppColors.textPrimaryDark 
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              // Theme Toggle
              Container(
                decoration: BoxDecoration(
                  color: isDark 
                      ? AppColors.surfaceDark 
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    context.read<AppProvider>().toggleTheme();
                  },
                  icon: Icon(
                    isDark 
                        ? Icons.light_mode_rounded 
                        : Icons.dark_mode_rounded,
                    color: isDark 
                        ? AppColors.textPrimaryDark 
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Notification Button
              Container(
                decoration: BoxDecoration(
                  color: isDark 
                      ? AppColors.surfaceDark 
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_rounded,
                        color: isDark 
                            ? AppColors.textPrimaryDark 
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark 
                                ? AppColors.surfaceDark 
                                : AppColors.surfaceLight,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: ShimmerCategoryChips(),
          );
        }

        final categories = provider.categories;
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.getHorizontalPadding(),
              ),
              itemCount: categories.length + 1, // +1 for "All" category
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CategoryChip(
                      label: 'All',
                      isSelected: provider.selectedCategory == 'All',
                      onTap: () => provider.filterByCategory('All'),
                    ),
                  );
                }
                
                final category = categories[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CategoryChip(
                    label: category.name,
                    icon: category.icon,
                    isSelected: provider.selectedCategory == category.name,
                    onTap: () => provider.filterByCategory(category.name),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showFilterSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark 
                      ? AppColors.borderDark 
                      : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Filter Professionals',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Rating',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                FilterChip(
                  label: const Text('4.5+'),
                  selected: false,
                  onSelected: (_) {},
                ),
                FilterChip(
                  label: const Text('4.0+'),
                  selected: false,
                  onSelected: (_) {},
                ),
                FilterChip(
                  label: const Text('3.5+'),
                  selected: false,
                  onSelected: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Availability',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                FilterChip(
                  label: const Text('Available Now'),
                  selected: false,
                  onSelected: (_) {},
                ),
                FilterChip(
                  label: const Text('This Week'),
                  selected: false,
                  onSelected: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: GradientButton(
                    text: 'Apply Filters',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _goToProfile(Professional professional) {
    context.read<AppProvider>().selectProfessional(professional);
    Navigator.pushNamed(context, '/professional-profile');
  }

  void _goToHire(Professional professional) {
    context.read<AppProvider>().selectProfessional(professional);
    Navigator.pushNamed(context, '/hire');
  }
}
