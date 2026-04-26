import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/custom_button.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> 
    with TickerProviderStateMixin {
  String? selectedGender;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
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
              progress: 5 / 7,
              actionText: 'Skip',
              onAction: () => Navigator.pushNamed(context, '/fitness-level'),
            ),
            
            SizedBox(height: 24.h),
            
            // Step Indicator
            const StepIndicator(currentStep: 5, totalSteps: 7),
            
            SizedBox(height: 20.h),
            
            // Heading
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'What is your gender?',
                textAlign: TextAlign.center,
                style: AppTheme.heading3.copyWith(fontSize: 24.sp, height: 1.3),
              ),
            ),
            
            SizedBox(height: 8.h),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'This helps us personalize your experience',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.grayText,
                ),
              ),
            ),
            
            // Gender Cards
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildGenderCard(
                        'Female',
                        _buildFemaleIllustration(),
                        AppTheme.femaleBg,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildGenderCard(
                        'Male',
                        _buildMaleIllustration(),
                        AppTheme.maleBg,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Continue Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: PrimaryButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.pushNamed(context, '/fitness-level');
                },
                enabled: selectedGender != null,
              ),
            ),
            
            SizedBox(height: Responsive.safeBottom + 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderCard(String gender, Widget illustration, Color bgColor) {
    final isSelected = selectedGender == gender;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: AnimatedBuilder(
        animation: _floatAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, isSelected ? -_floatAnimation.value : 0),
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24.r),
            border: isSelected 
                ? Border.all(color: AppTheme.primaryPurple, width: 3)
                : null,
            boxShadow: isSelected 
                ? AppTheme.selectedCardShadow 
                : AppTheme.cardShadow,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(child: illustration),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryPurple : AppTheme.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  gender,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppTheme.white : AppTheme.darkText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFemaleIllustration() {
    return CustomPaint(
      size: Size(100.w, 140.h),
      painter: _FemaleYogaPainter(),
    );
  }

  Widget _buildMaleIllustration() {
    return CustomPaint(
      size: Size(100.w, 140.h),
      painter: _MaleYogaPainter(),
    );
  }
}

class _FemaleYogaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final skinColor = const Color(0xFFFFDBB4);
    final hairColor = const Color(0xFF5D4037);
    final clothesColor = AppTheme.lightPurple;
    
    // Body sitting in meditation pose
    final bodyPaint = Paint()..color = clothesColor;
    final skinPaint = Paint()..color = skinColor;
    final hairPaint = Paint()..color = hairColor;
    
    final cx = size.width / 2;
    final cy = size.height / 2;
    
    // Crossed legs
    final legPath = Path();
    legPath.moveTo(cx - 40, cy + 40);
    legPath.quadraticBezierTo(cx, cy + 60, cx + 40, cy + 40);
    legPath.quadraticBezierTo(cx + 35, cy + 50, cx, cy + 45);
    legPath.quadraticBezierTo(cx - 35, cy + 50, cx - 40, cy + 40);
    canvas.drawPath(legPath, bodyPaint);
    
    // Torso
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 10), width: 50, height: 60),
      bodyPaint,
    );
    
    // Head
    canvas.drawCircle(Offset(cx, cy - 35), 25, skinPaint);
    
    // Hair
    final hairPath = Path();
    hairPath.addArc(
      Rect.fromCenter(center: Offset(cx, cy - 40), width: 54, height: 50),
      3.14,
      3.14,
    );
    hairPath.quadraticBezierTo(cx - 30, cy - 25, cx - 28, cy - 10);
    hairPath.quadraticBezierTo(cx, cy - 15, cx + 28, cy - 10);
    hairPath.quadraticBezierTo(cx + 30, cy - 25, cx + 27, cy - 65);
    canvas.drawPath(hairPath, hairPaint);
    
    // Arms in meditation position
    final leftArmPath = Path();
    leftArmPath.moveTo(cx - 25, cy + 5);
    leftArmPath.quadraticBezierTo(cx - 45, cy + 20, cx - 35, cy + 35);
    canvas.drawPath(
      leftArmPath,
      Paint()
        ..color = skinColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round,
    );
    
    final rightArmPath = Path();
    rightArmPath.moveTo(cx + 25, cy + 5);
    rightArmPath.quadraticBezierTo(cx + 45, cy + 20, cx + 35, cy + 35);
    canvas.drawPath(
      rightArmPath,
      Paint()
        ..color = skinColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round,
    );
    
    // Eyes (closed)
    final eyePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx - 8, cy - 35), width: 8, height: 4),
      0,
      3.14,
      false,
      eyePaint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + 8, cy - 35), width: 8, height: 4),
      0,
      3.14,
      false,
      eyePaint,
    );
    
    // Smile
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - 28), width: 12, height: 8),
      0.2,
      2.7,
      false,
      eyePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MaleYogaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final skinColor = const Color(0xFFE8B89D);
    final hairColor = const Color(0xFF3E2723);
    final clothesColor = AppTheme.primaryPurple;
    
    final bodyPaint = Paint()..color = clothesColor;
    final skinPaint = Paint()..color = skinColor;
    final hairPaint = Paint()..color = hairColor;
    
    final cx = size.width / 2;
    final cy = size.height / 2;
    
    // Crossed legs
    final legPath = Path();
    legPath.moveTo(cx - 40, cy + 40);
    legPath.quadraticBezierTo(cx, cy + 60, cx + 40, cy + 40);
    legPath.quadraticBezierTo(cx + 35, cy + 50, cx, cy + 45);
    legPath.quadraticBezierTo(cx - 35, cy + 50, cx - 40, cy + 40);
    canvas.drawPath(legPath, bodyPaint);
    
    // Torso (slightly broader)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 10), width: 55, height: 60),
      bodyPaint,
    );
    
    // Head
    canvas.drawCircle(Offset(cx, cy - 35), 25, skinPaint);
    
    // Short hair
    final hairPath = Path();
    hairPath.addArc(
      Rect.fromCenter(center: Offset(cx, cy - 42), width: 52, height: 40),
      3.14,
      3.14,
    );
    canvas.drawPath(hairPath, hairPaint);
    
    // Arms raised up
    final leftArmPath = Path();
    leftArmPath.moveTo(cx - 25, cy);
    leftArmPath.quadraticBezierTo(cx - 50, cy - 20, cx - 35, cy - 50);
    canvas.drawPath(
      leftArmPath,
      Paint()
        ..color = skinColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round,
    );
    
    final rightArmPath = Path();
    rightArmPath.moveTo(cx + 25, cy);
    rightArmPath.quadraticBezierTo(cx + 50, cy - 20, cx + 35, cy - 50);
    canvas.drawPath(
      rightArmPath,
      Paint()
        ..color = skinColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round,
    );
    
    // Hands touching above head
    canvas.drawCircle(Offset(cx - 35, cy - 55), 8, skinPaint);
    canvas.drawCircle(Offset(cx + 35, cy - 55), 8, skinPaint);
    
    // Eyes (closed)
    final eyePaint = Paint()
      ..color = const Color(0xFF3E2723)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx - 8, cy - 35), width: 8, height: 4),
      0,
      3.14,
      false,
      eyePaint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + 8, cy - 35), width: 8, height: 4),
      0,
      3.14,
      false,
      eyePaint,
    );
    
    // Smile
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - 28), width: 12, height: 8),
      0.2,
      2.7,
      false,
      eyePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
