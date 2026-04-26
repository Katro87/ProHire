import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({super.key});

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  int selectedNavIndex = 0;
  int selectedCategoryIndex = 0;
  
  final List<String> categories = ['All', 'Meditation', 'Sleep', 'Fitness', 'Nutrition'];
  
  final List<Map<String, dynamic>> podcasts = [
    {
      'title': 'Morning Meditation',
      'host': 'Sarah Johnson',
      'duration': '15 min',
      'image': '🧘',
      'color': AppTheme.meditationBg,
    },
    {
      'title': 'Sleep Stories',
      'host': 'Michael Chen',
      'duration': '30 min',
      'image': '😴',
      'color': AppTheme.sleepBg,
    },
    {
      'title': 'HIIT Workout',
      'host': 'Emma Davis',
      'duration': '20 min',
      'image': '🏃',
      'color': AppTheme.sportsBg,
    },
    {
      'title': 'Healthy Eating',
      'host': 'Alex Turner',
      'duration': '25 min',
      'image': '🥗',
      'color': AppTheme.nutritionBg,
    },
    {
      'title': 'Stress Relief',
      'host': 'Lisa Park',
      'duration': '18 min',
      'image': '🌿',
      'color': AppTheme.organicBg,
    },
    {
      'title': 'Yoga Flow',
      'host': 'David Miller',
      'duration': '45 min',
      'image': '🧘‍♀️',
      'color': AppTheme.veganBg,
    },
  ];

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return Scaffold(
      backgroundColor: AppTheme.softPurpleBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning! 👋',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppTheme.grayText,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Discover',
                        style: AppTheme.heading2.copyWith(fontSize: 28.sp),
                      ),
                    ],
                  ),
                  // Profile & Notification
                  Row(
                    children: [
                      _buildIconButton(Icons.search_outlined),
                      SizedBox(width: 12.w),
                      _buildIconButton(Icons.notifications_outlined),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Featured Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildFeaturedCard(),
            ),
            
            SizedBox(height: 24.h),
            
            // Categories
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final isSelected = index == selectedCategoryIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 12.w),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryPurple : AppTheme.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? AppTheme.white : AppTheme.grayText,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Wellness Grid Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Sessions',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Podcast Grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.isMobile ? 2 : 3,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.85,
                ),
                itemCount: podcasts.length,
                itemBuilder: (context, index) {
                  return _buildPodcastCard(podcasts[index]);
                },
              ),
            ),
            
            // Bottom Navigation
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(icon, size: 22.sp, color: AppTheme.darkText),
    );
  }

  Widget _buildFeaturedCard() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/podcast-detail'),
      child: Container(
        height: 160.h,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: AppTheme.selectedCardShadow,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppTheme.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '✨ Featured',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Daily Wellness\nJourney',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '12 sessions • 4 hours',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppTheme.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppTheme.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  '🧘‍♂️',
                  style: TextStyle(fontSize: 40.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodcastCard(Map<String, dynamic> podcast) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/podcast-detail'),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 90.h,
              decoration: BoxDecoration(
                color: podcast['color'],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: Center(
                child: Text(
                  podcast['image'],
                  style: TextStyle(fontSize: 40.sp),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    podcast['title'],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    podcast['host'],
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.grayText,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.sp,
                        color: AppTheme.grayText,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        podcast['duration'],
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppTheme.grayText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final items = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home'},
      {'icon': Icons.explore_outlined, 'activeIcon': Icons.explore, 'label': 'Explore'},
      {'icon': Icons.favorite_outline, 'activeIcon': Icons.favorite, 'label': 'Saved'},
      {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': 'Profile'},
    ];

    return Container(
      height: 70.h + Responsive.safeBottom,
      padding: EdgeInsets.only(bottom: Responsive.safeBottom),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == selectedNavIndex;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedNavIndex = index;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? item['activeIcon'] as IconData : item['icon'] as IconData,
                  size: 24.sp,
                  color: isSelected ? AppTheme.primaryPurple : AppTheme.grayText,
                ),
                SizedBox(height: 4.h),
                Text(
                  item['label'] as String,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? AppTheme.primaryPurple : AppTheme.grayText,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
