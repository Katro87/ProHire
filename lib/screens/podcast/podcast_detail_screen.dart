import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/custom_button.dart';

class PodcastDetailScreen extends StatefulWidget {
  const PodcastDetailScreen({super.key});

  @override
  State<PodcastDetailScreen> createState() => _PodcastDetailScreenState();
}

class _PodcastDetailScreenState extends State<PodcastDetailScreen> {
  int selectedTab = 0;
  
  final List<Map<String, dynamic>> sessions = [
    {'title': 'Introduction to Wellness', 'duration': '5:30', 'isPlaying': false},
    {'title': 'Morning Breathing', 'duration': '12:45', 'isPlaying': true},
    {'title': 'Mindful Movement', 'duration': '15:20', 'isPlaying': false},
    {'title': 'Stress Release', 'duration': '18:00', 'isPlaying': false},
    {'title': 'Evening Wind Down', 'duration': '20:15', 'isPlaying': false},
    {'title': 'Sleep Preparation', 'duration': '25:00', 'isPlaying': false},
  ];

  final List<Map<String, dynamic>> reviews = [
    {
      'name': 'Emily R.',
      'rating': 5,
      'comment': 'Life-changing sessions! Highly recommend.',
      'date': '2 days ago',
    },
    {
      'name': 'James M.',
      'rating': 4,
      'comment': 'Great content, very relaxing.',
      'date': '1 week ago',
    },
    {
      'name': 'Sophie L.',
      'rating': 5,
      'comment': 'Perfect for my morning routine.',
      'date': '2 weeks ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 280.h,
            pinned: true,
            backgroundColor: AppTheme.primaryPurple,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppTheme.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppTheme.white,
                  size: 20.sp,
                ),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(8.w),
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.favorite_outline,
                    color: AppTheme.white,
                    size: 20.sp,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(right: 16.w, top: 8.w, bottom: 8.w),
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.share_outlined,
                    color: AppTheme.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.playerGradient,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 60.h),
                      Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          color: AppTheme.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Center(
                          child: Text(
                            '🧘‍♂️',
                            style: TextStyle(fontSize: 60.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: Offset(0, -24.h),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    
                    // Title & Host Info
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Wellness Journey',
                            style: AppTheme.heading3.copyWith(fontSize: 24.sp),
                          ),
                          SizedBox(height: 16.h),
                          _buildHostInfo(),
                          SizedBox(height: 16.h),
                          _buildStats(),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Tabs
                    _buildTabs(),
                    
                    SizedBox(height: 16.h),
                    
                    // Tab Content
                    selectedTab == 0 ? _buildSessionsList() : _buildReviewsList(),
                    
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      
      // Play Button
      bottomSheet: Container(
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 16.h,
          bottom: Responsive.safeBottom + 16.h,
        ),
        decoration: BoxDecoration(
          color: AppTheme.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -4),
              blurRadius: 16,
            ),
          ],
        ),
        child: PrimaryButton(
          text: 'Start Session',
          icon: Icons.play_arrow_rounded,
          onPressed: () {
            Navigator.pushNamed(context, '/now-playing');
          },
        ),
      ),
    );
  }

  Widget _buildHostInfo() {
    return Row(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text(
              'SJ',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sarah Johnson',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText,
                ),
              ),
              Text(
                'Wellness Coach',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppTheme.grayText,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppTheme.softPurpleBg,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            'Follow',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryPurple,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _buildStatItem(Icons.star_rounded, '4.9', AppTheme.starYellow),
        SizedBox(width: 24.w),
        _buildStatItem(Icons.access_time, '4h 30m', AppTheme.grayText),
        SizedBox(width: 24.w),
        _buildStatItem(Icons.headphones_outlined, '12 sessions', AppTheme.grayText),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: iconColor),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppTheme.grayText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          _buildTab('Sessions', 0),
          SizedBox(width: 16.w),
          _buildTab('Reviews', 1),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppTheme.primaryPurple : AppTheme.grayText,
            ),
          ),
          SizedBox(height: 8.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3.h,
            width: isSelected ? 24.w : 0,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: sessions.asMap().entries.map((entry) {
          final index = entry.key;
          final session = entry.value;
          return _buildSessionItem(index + 1, session);
        }).toList(),
      ),
    );
  }

  Widget _buildSessionItem(int number, Map<String, dynamic> session) {
    final isPlaying = session['isPlaying'] as bool;
    
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/now-playing'),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isPlaying ? AppTheme.softPurpleBg : AppTheme.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isPlaying ? AppTheme.primaryPurple : AppTheme.borderLight,
          ),
        ),
        child: Row(
          children: [
            // Number/Play icon
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: isPlaying ? AppTheme.primaryPurple : AppTheme.softPurpleBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: isPlaying
                    ? Icon(Icons.pause, size: 20.sp, color: AppTheme.white)
                    : Text(
                        number.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session['title'] as String,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.darkText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    session['duration'] as String,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppTheme.grayText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.play_circle_outline,
              size: 28.sp,
              color: AppTheme.primaryPurple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: reviews.map((review) => _buildReviewItem(review)).toList(),
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppTheme.softPurpleBg,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    (review['name'] as String).substring(0, 1),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'] as String,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkText,
                      ),
                    ),
                    Text(
                      review['date'] as String,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.grayText,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < (review['rating'] as int)
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 16.sp,
                    color: AppTheme.starYellow,
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            review['comment'] as String,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.grayText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
