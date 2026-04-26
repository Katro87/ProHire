import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive_utils.dart';
import '../../widgets/common_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      icon: Icons.search_rounded,
      title: 'Find Professionals',
      description: 'Browse through our extensive network of verified professionals in various fields. From developers to plumbers, find the perfect match for your needs.',
      color: AppColors.primary,
    ),
    OnboardingPageData(
      icon: Icons.handshake_rounded,
      title: 'Easy Hiring',
      description: 'Connect and hire professionals with just a few taps. View portfolios, ratings, and reviews to make informed decisions.',
      color: AppColors.secondary,
    ),
    OnboardingPageData(
      icon: Icons.star_rounded,
      title: 'Quality Service',
      description: 'Get top-quality service from verified professionals. Track your projects and leave reviews to help others.',
      color: AppColors.accent,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.normalAnimation,
        curve: Curves.easeInOut,
      );
    } else {
      _goToHome();
    }
  }

  void _goToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.getHorizontalPadding(),
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _goToHome,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark 
                            ? AppColors.textSecondaryDark 
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _pages[index]);
                },
              ),
            ),

            // Bottom Section
            Padding(
              padding: EdgeInsets.all(Responsive.getHorizontalPadding()),
              child: Column(
                children: [
                  // Page Indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: isDark 
                          ? AppColors.borderDark 
                          : AppColors.borderLight,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 4,
                      spacing: 8,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Navigation Buttons
                  Row(
                    children: [
                      if (_currentPage > 0) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: AppConstants.normalAnimation,
                                curve: Curves.easeInOut,
                              );
                            },
                            child: const Text('Back'),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Expanded(
                        flex: _currentPage > 0 ? 2 : 1,
                        child: GradientButton(
                          text: _currentPage == _pages.length - 1
                              ? 'Get Started'
                              : 'Next',
                          onPressed: _nextPage,
                          icon: _currentPage == _pages.length - 1
                              ? Icons.arrow_forward_rounded
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.getHorizontalPadding(),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          
          if (isLandscape) {
            return Row(
              children: [
                Expanded(
                  child: _buildIllustration(context),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildContent(context, isDark),
                ),
              ],
            );
          }
          
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: _buildIllustration(context),
              ),
              const SizedBox(height: 32),
              Expanded(
                flex: 2,
                child: _buildContent(context, isDark),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.8, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Container(
          width: Responsive.isTablet ? 280 : 200,
          height: Responsive.isTablet ? 280 : 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                data.color.withOpacity(0.2),
                data.color.withOpacity(0.1),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: data.color.withOpacity(0.3),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: Responsive.isTablet ? 180 : 128,
              height: Responsive.isTablet ? 180 : 128,
              decoration: BoxDecoration(
                color: data.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: data.color.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                data.icon,
                size: Responsive.isTablet ? 80 : 64,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          data.title,
          style: TextStyle(
            fontSize: Responsive.isTablet ? 32 : 28,
            fontWeight: FontWeight.w800,
            color: isDark 
                ? AppColors.textPrimaryDark 
                : AppColors.textPrimaryLight,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          data.description,
          style: TextStyle(
            fontSize: Responsive.isTablet ? 17 : 15,
            color: isDark 
                ? AppColors.textSecondaryDark 
                : AppColors.textSecondaryLight,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
