import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/custom_button.dart';

class FitnessLevelScreen extends StatefulWidget {
  const FitnessLevelScreen({super.key});

  @override
  State<FitnessLevelScreen> createState() => _FitnessLevelScreenState();
}

class _FitnessLevelScreenState extends State<FitnessLevelScreen> 
    with SingleTickerProviderStateMixin {
  int selectedLevel = 1;
  late PageController _pageController;
  late AnimationController _pulseController;
  
  final List<Map<String, dynamic>> fitnessLevels = [
    {
      'level': 'Beginner',
      'description': 'New to fitness or haven\'t worked out in a while',
      'color': AppTheme.successGreen,
      'bars': 1,
    },
    {
      'level': 'Intermediate',
      'description': 'You work out 2-3 times a week regularly',
      'color': AppTheme.yellowGold,
      'bars': 2,
    },
    {
      'level': 'Advanced',
      'description': 'You\'re active and work out almost every day',
      'color': AppTheme.coralPink,
      'bars': 3,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: selectedLevel,
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            
            // Navigation Header
            NavigationHeader(
              progress: 6 / 7,
              actionText: 'Skip',
              onAction: () => Navigator.pushNamed(context, '/notifications'),
            ),
            
            SizedBox(height: 24.h),
            
            // Step Indicator
            const StepIndicator(currentStep: 6, totalSteps: 7),
            
            SizedBox(height: 20.h),
            
            // Heading
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'What\'s your fitness level?',
                textAlign: TextAlign.center,
                style: AppTheme.heading3.copyWith(fontSize: 24.sp, height: 1.3),
              ),
            ),
            
            SizedBox(height: 8.h),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'We\'ll customize your workout intensity',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.grayText,
                ),
              ),
            ),
            
            SizedBox(height: 32.h),
            
            // Fitness Level Cards (Swipeable)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    selectedLevel = index;
                  });
                },
                itemCount: fitnessLevels.length,
                itemBuilder: (context, index) {
                  final level = fitnessLevels[index];
                  final isSelected = index == selectedLevel;
                  
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double scale = 1.0;
                      if (_pageController.position.haveDimensions) {
                        double pageOffset = _pageController.page! - index;
                        scale = (1 - (pageOffset.abs() * 0.15)).clamp(0.85, 1.0);
                      }
                      
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: _buildFitnessCard(level, isSelected),
                  );
                },
              ),
            ),
            
            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(fitnessLevels.length, (index) {
                final isSelected = index == selectedLevel;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: isSelected ? 24.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryPurple : AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                );
              }),
            ),
            
            SizedBox(height: 24.h),
            
            // Continue Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: PrimaryButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
            ),
            
            SizedBox(height: Responsive.safeBottom + 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFitnessCard(Map<String, dynamic> level, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: isSelected ? AppTheme.primaryGradient : null,
        color: isSelected ? null : AppTheme.softPurpleBg,
        borderRadius: BorderRadius.circular(32.r),
        border: isSelected ? null : Border.all(color: AppTheme.borderLight),
        boxShadow: isSelected ? AppTheme.selectedCardShadow : AppTheme.cardShadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Fitness Illustration
          Expanded(
            child: CustomPaint(
              size: Size(140.w, 140.h),
              painter: _FitnessIllustrationPainter(
                level: level['bars'] as int,
                color: level['color'] as Color,
              ),
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // Level Name
          Text(
            level['level'] as String,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppTheme.white : AppTheme.darkText,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          // Description
          Text(
            level['description'] as String,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: isSelected 
                  ? AppTheme.white.withValues(alpha: 0.8) 
                  : AppTheme.grayText,
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // Intensity Bars
          _buildIntensityBars(level['bars'] as int, isSelected),
        ],
      ),
    );
  }

  Widget _buildIntensityBars(int activeBars, bool isSelected) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index < activeBars;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: 40.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isActive 
                ? (isSelected ? AppTheme.white : AppTheme.primaryPurple)
                : (isSelected 
                    ? AppTheme.white.withValues(alpha: 0.3) 
                    : AppTheme.lightGray),
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}

class _FitnessIllustrationPainter extends CustomPainter {
  final int level;
  final Color color;

  _FitnessIllustrationPainter({required this.level, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    
    // Base person doing exercise
    final skinColor = const Color(0xFFFFDBB4);
    final clothesColor = AppTheme.lightPurple;
    
    final skinPaint = Paint()..color = skinColor;
    final clothesPaint = Paint()..color = clothesColor;
    
    // Head
    canvas.drawCircle(Offset(cx, cy - 40), 20, skinPaint);
    
    // Body
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: 45, height: 60),
      clothesPaint,
    );
    
    // Arms based on fitness level
    final armPaint = Paint()
      ..color = skinColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    
    if (level == 1) {
      // Beginner - arms at sides
      canvas.drawLine(Offset(cx - 22, cy - 10), Offset(cx - 35, cy + 20), armPaint);
      canvas.drawLine(Offset(cx + 22, cy - 10), Offset(cx + 35, cy + 20), armPaint);
    } else if (level == 2) {
      // Intermediate - arms bent
      final leftArm = Path();
      leftArm.moveTo(cx - 22, cy - 10);
      leftArm.quadraticBezierTo(cx - 45, cy - 10, cx - 40, cy - 35);
      canvas.drawPath(leftArm, armPaint);
      
      final rightArm = Path();
      rightArm.moveTo(cx + 22, cy - 10);
      rightArm.quadraticBezierTo(cx + 45, cy - 10, cx + 40, cy - 35);
      canvas.drawPath(rightArm, armPaint);
    } else {
      // Advanced - arms fully up with weights
      canvas.drawLine(Offset(cx - 22, cy - 10), Offset(cx - 30, cy - 55), armPaint);
      canvas.drawLine(Offset(cx + 22, cy - 10), Offset(cx + 30, cy - 55), armPaint);
      
      // Dumbbells
      final dumbellPaint = Paint()..color = AppTheme.navyBlue;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx - 30, cy - 60), width: 25, height: 8),
          const Radius.circular(4),
        ),
        dumbellPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx + 30, cy - 60), width: 25, height: 8),
          const Radius.circular(4),
        ),
        dumbellPaint,
      );
    }
    
    // Legs
    final legPaint = Paint()
      ..color = clothesColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(Offset(cx - 10, cy + 25), Offset(cx - 20, cy + 55), legPaint);
    canvas.drawLine(Offset(cx + 10, cy + 25), Offset(cx + 20, cy + 55), legPaint);
    
    // Shoes
    final shoePaint = Paint()..color = AppTheme.navyBlue;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - 22, cy + 60), width: 18, height: 10),
      shoePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 22, cy + 60), width: 18, height: 10),
      shoePaint,
    );
    
    // Hair
    final hairPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - 45), width: 42, height: 35),
      3.14,
      3.14,
      true,
      hairPaint,
    );
    
    // Face
    final facePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Eyes
    canvas.drawCircle(Offset(cx - 6, cy - 42), 2, Paint()..color = const Color(0xFF5D4037));
    canvas.drawCircle(Offset(cx + 6, cy - 42), 2, Paint()..color = const Color(0xFF5D4037));
    
    // Smile
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - 35), width: 10, height: 8),
      0.2,
      2.7,
      false,
      facePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
