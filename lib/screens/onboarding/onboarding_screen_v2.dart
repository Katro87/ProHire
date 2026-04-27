import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_colors_v2.dart';
import '../../core/utils/screen_utils.dart';
import '../../widgets/premium_widgets.dart';

class OnboardingScreenV2 extends StatefulWidget {
  const OnboardingScreenV2({super.key});

  @override
  State<OnboardingScreenV2> createState() => _OnboardingScreenV2State();
}

class _OnboardingScreenV2State extends State<OnboardingScreenV2> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      emoji: '🔧',
      title: 'Find Skilled Trades',
      description:
          'Connect with verified plumbers, electricians, carpenters and more for your home projects',
      gradient: AppColors.tradeGradient,
    ),
    OnboardingPage(
      emoji: '💼',
      title: 'Hire Freelancers',
      description:
          'Access top designers, developers, writers and other creative professionals',
      gradient: AppColors.freelanceGradient,
    ),
    OnboardingPage(
      emoji: '⭐',
      title: 'Quality Guaranteed',
      description:
          'All professionals are verified with reviews and ratings from real clients',
      gradient: AppColors.primaryGradient,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final user = FirebaseAuth.instance.currentUser;
      Navigator.pushReplacementNamed(context, user != null ? '/home' : '/auth');
    }
  }

  void _skipToEnd() {
    final user = FirebaseAuth.instance.currentUser;
    Navigator.pushReplacementNamed(context, user != null ? '/home' : '/auth');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
      body: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _OnboardingPageWidget(
                page: _pages[index],
                screen: screen,
              );
            },
          ),

          // Top skip button
          Positioned(
            top: screen.safeTop + 16,
            right: 16,
            child: TextButton(
              onPressed: _skipToEnd,
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: screen.fontSize(14),
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: screen.safeBottom + 24,
            left: 24,
            right: 24,
            child: Column(
              children: [
                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Continue button
                PremiumButton(
                  text: _currentPage == _pages.length - 1
                      ? 'Get Started'
                      : 'Continue',
                  onPressed: _nextPage,
                  gradient: _pages[_currentPage].gradient,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String emoji;
  final String title;
  final String description;
  final LinearGradient gradient;

  OnboardingPage({
    required this.emoji,
    required this.title,
    required this.description,
    required this.gradient,
  });
}

class _OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final ScreenInfo screen;

  const _OnboardingPageWidget({
    required this.page,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screen.horizontalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large emoji with gradient background
          Container(
            width: screen.isMobile ? 160 : 200,
            height: screen.isMobile ? 160 : 200,
            decoration: BoxDecoration(
              gradient: page.gradient,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: page.gradient.colors.first.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Center(
              child: Text(
                page.emoji,
                style: TextStyle(
                  fontSize: screen.isMobile ? 80 : 100,
                ),
              ),
            ),
          ),
          SizedBox(height: screen.isMobile ? 48 : 64),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screen.fontSize(28),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryLight,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),

          // Description
          ContentConstraint(
            maxWidth: 400,
            child: Text(
              page.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screen.fontSize(16),
                color: AppColors.textSecondaryLight,
                height: 1.5,
              ),
            ),
          ),
          
          // Space for bottom controls
          const SizedBox(height: 150),
        ],
      ),
    );
  }
}
