import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/custom_button.dart';

class EnableFingerprintScreen extends StatefulWidget {
  const EnableFingerprintScreen({super.key});

  @override
  State<EnableFingerprintScreen> createState() => _EnableFingerprintScreenState();
}

class _EnableFingerprintScreenState extends State<EnableFingerprintScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
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
              progress: 2 / 7,
              actionText: 'Skip',
              onAction: () => Navigator.pushNamed(context, '/profile-picture'),
            ),
            
            SizedBox(height: 24.h),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Step Indicator
                    const StepIndicator(currentStep: 1, totalSteps: 7),
                    
                    SizedBox(height: 20.h),
                    
                    // Illustration
                    SizedBox(
                      height: 220.h,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: _buildIllustration(),
                            );
                          },
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 20.h),
                    
                    // Heading
                    Text(
                      'Enable Fingerprint',
                      style: AppTheme.heading3.copyWith(fontSize: 24.sp),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Description
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        "If you enable touch ID, you don't\nneed to enter your password when\nyou login.",
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyText.copyWith(
                          fontSize: 15.sp,
                          height: 1.5,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 60.h),
                  ],
                ),
              ),
            ),
            
            // Activate Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: PrimaryButton(
                text: 'Activate',
                onPressed: () {
                  Navigator.pushNamed(context, '/profile-picture');
                },
              ),
            ),
            
            SizedBox(height: Responsive.safeBottom + 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return SizedBox(
      width: 200.w,
      height: 200.w,
      child: CustomPaint(
        painter: _FingerprintIllustrationPainter(),
      ),
    );
  }
}

class _FingerprintIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background gradient circle
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFA29BFE), Color(0xFFDDD6FE)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.45));
    canvas.drawCircle(center, size.width * 0.45, bgPaint);
    
    // Phone
    final phonePaint = Paint()..color = const Color(0xFF2D3436);
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + size.width * 0.08, center.dy),
        width: size.width * 0.32,
        height: size.height * 0.5,
      ),
      Radius.circular(size.width * 0.04),
    );
    canvas.drawRRect(phoneRect, phonePaint);
    
    // Screen
    final screenPaint = Paint()..color = const Color(0xFF1A1A2E);
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + size.width * 0.08, center.dy),
        width: size.width * 0.27,
        height: size.height * 0.44,
      ),
      Radius.circular(size.width * 0.02),
    );
    canvas.drawRRect(screenRect, screenPaint);
    
    // Fingerprint on screen
    final fpCenter = Offset(center.dx + size.width * 0.08, center.dy);
    final fpPaint = Paint()
      ..color = AppTheme.primaryPurple.withAlpha(200)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    for (int i = 1; i <= 4; i++) {
      canvas.drawArc(
        Rect.fromCenter(center: fpCenter, width: 12.0 * i, height: 16.0 * i),
        0.5,
        2.0,
        false,
        fpPaint,
      );
    }
    
    // Person holding phone
    // Body
    final bodyPaint = Paint()..color = const Color(0xFF6C5CE7);
    canvas.drawOval(Rect.fromCenter(
      center: Offset(center.dx - size.width * 0.18, center.dy + size.height * 0.12),
      width: size.width * 0.28,
      height: size.height * 0.32,
    ), bodyPaint);
    
    // Head
    final skinPaint = Paint()..color = const Color(0xFFFFD5C2);
    canvas.drawCircle(
      Offset(center.dx - size.width * 0.18, center.dy - size.height * 0.12),
      size.width * 0.1,
      skinPaint,
    );
    
    // Hair
    final hairPaint = Paint()..color = const Color(0xFF6C5CE7);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx - size.width * 0.18, center.dy - size.height * 0.16),
        width: size.width * 0.22,
        height: size.height * 0.12,
      ),
      3.14159,
      3.14159,
      false,
      hairPaint..style = PaintingStyle.fill,
    );
    
    // Arm holding phone
    final armPaint = Paint()
      ..color = const Color(0xFFFFD5C2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx - size.width * 0.08, center.dy + size.height * 0.05),
      Offset(center.dx + size.width * 0.02, center.dy + size.height * 0.15),
      armPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
