import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/custom_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _fadeController;
  late Animation<double> _floatAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate available space for illustration
              final availableHeight = constraints.maxHeight;
              final illustrationHeight = (availableHeight * 0.3).clamp(120.0, 240.0);
              final topPadding = Responsive.isDesktop ? 20.h : 30.h;
              final bottomPadding = Responsive.safeBottom + 16.h;
              
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top content
                        Column(
                          children: [
                            SizedBox(height: topPadding),
                            
                            // Logo
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: _buildLogo(),
                            ),
                            
                            SizedBox(height: 16.h),
                            
                            // Welcome Text
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Column(
                                children: [
                                  Text(
                                    'Welcome to',
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.normal,
                                      color: AppTheme.grayText,
                                    ),
                                  ),
                                  ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [Color(0xFF6C5CE7), Color(0xFF4834DF)],
                                    ).createShader(bounds),
                                    child: Text(
                                      'Momkaro UI Kit',
                                      style: TextStyle(
                                        fontSize: 32.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                                    child: Text(
                                      'The best UI Kit for your next\nhealth and fitness project!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: AppTheme.grayText,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        // Illustration - flexible size
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: AnimatedBuilder(
                            animation: _floatAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _floatAnimation.value),
                                child: SizedBox(
                                  height: illustrationHeight,
                                  child: Center(
                                    child: _buildIllustration(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        
                        // Buttons at bottom
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PrimaryButton(
                                text: 'Get Started',
                                onPressed: () {
                                  Navigator.pushNamed(context, '/mobile-input');
                                },
                              ),
                              SizedBox(height: 16.h),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Navigate to sign in
                                    Navigator.pushNamed(context, '/mobile-input');
                                  },
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Already have account? ',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppTheme.grayText,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Sign in',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.primaryPurple,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: CustomPaint(
        painter: _LogoPainter(),
      ),
    );
  }

  Widget _buildIllustration() {
    return SizedBox(
      width: Responsive.maxContentWidth(),
      height: 240.h,
      child: CustomPaint(
        painter: _WelcomeIllustrationPainter(),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    path.moveTo(centerX - 12, centerY);
    path.quadraticBezierTo(centerX - 12, centerY - 8, centerX - 4, centerY - 8);
    path.quadraticBezierTo(centerX + 4, centerY - 8, centerX + 4, centerY);
    path.quadraticBezierTo(centerX + 4, centerY + 8, centerX + 12, centerY + 8);
    path.quadraticBezierTo(centerX + 20, centerY + 8, centerX + 12, centerY);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WelcomeIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Abstract curved background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFA29BFE), Color(0xFF6C5CE7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCenter(center: center, width: size.width, height: size.height));
    
    final bgPath = Path();
    bgPath.moveTo(0, size.height * 0.4);
    bgPath.quadraticBezierTo(size.width * 0.25, size.height * 0.2, size.width * 0.5, size.height * 0.35);
    bgPath.quadraticBezierTo(size.width * 0.75, size.height * 0.5, size.width, size.height * 0.3);
    bgPath.lineTo(size.width, size.height);
    bgPath.lineTo(0, size.height);
    bgPath.close();
    canvas.drawPath(bgPath, bgPaint..style = PaintingStyle.fill);
    
    // Person 1 - Yoga (purple)
    _drawYogaPerson(canvas, Offset(center.dx - size.width * 0.28, center.dy + size.height * 0.12), size.width * 0.22, const Color(0xFF6C5CE7));
    
    // Person 2 - Running (blue)
    _drawRunningPerson(canvas, Offset(center.dx + size.width * 0.05, center.dy - size.height * 0.05), size.width * 0.2, const Color(0xFF74B9FF));
    
    // Person 3 - Stretching (pink)
    _drawStretchingPerson(canvas, Offset(center.dx + size.width * 0.28, center.dy + size.height * 0.15), size.width * 0.2, const Color(0xFFFF7675));
    
    // Decorative dots
    final dotPaint = Paint()..style = PaintingStyle.fill;
    dotPaint.color = const Color(0xFFFDCB6E).withAlpha(150);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.25), 6, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.88, size.height * 0.3), 5, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.92, size.height * 0.65), 8, dotPaint);
  }
  
  void _drawYogaPerson(Canvas canvas, Offset pos, double scale, Color color) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    
    canvas.drawOval(Rect.fromCenter(
      center: Offset(pos.dx, pos.dy + scale * 0.15),
      width: scale * 0.7,
      height: scale * 0.4,
    ), paint);
    
    final skinPaint = Paint()..color = const Color(0xFFFFD5C2);
    canvas.drawCircle(Offset(pos.dx, pos.dy - scale * 0.25), scale * 0.18, skinPaint);
    
    final armPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.1
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(pos.dx - scale * 0.15, pos.dy),
      Offset(pos.dx - scale * 0.4, pos.dy - scale * 0.4),
      armPaint,
    );
    canvas.drawLine(
      Offset(pos.dx + scale * 0.15, pos.dy),
      Offset(pos.dx + scale * 0.4, pos.dy - scale * 0.4),
      armPaint,
    );
  }
  
  void _drawRunningPerson(Canvas canvas, Offset pos, double scale, Color color) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    
    canvas.drawOval(Rect.fromCenter(
      center: Offset(pos.dx, pos.dy + scale * 0.1),
      width: scale * 0.4,
      height: scale * 0.55,
    ), paint);
    
    final skinPaint = Paint()..color = const Color(0xFFFFD5C2);
    canvas.drawCircle(Offset(pos.dx + scale * 0.05, pos.dy - scale * 0.28), scale * 0.15, skinPaint);
    
    final legPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.12
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(pos.dx - scale * 0.1, pos.dy + scale * 0.35),
      Offset(pos.dx - scale * 0.35, pos.dy + scale * 0.7),
      legPaint,
    );
    canvas.drawLine(
      Offset(pos.dx + scale * 0.1, pos.dy + scale * 0.35),
      Offset(pos.dx + scale * 0.4, pos.dy + scale * 0.55),
      legPaint,
    );
  }
  
  void _drawStretchingPerson(Canvas canvas, Offset pos, double scale, Color color) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    
    canvas.drawOval(Rect.fromCenter(
      center: Offset(pos.dx, pos.dy + scale * 0.05),
      width: scale * 0.45,
      height: scale * 0.55,
    ), paint);
    
    final skinPaint = Paint()..color = const Color(0xFFFFD5C2);
    canvas.drawCircle(Offset(pos.dx, pos.dy - scale * 0.35), scale * 0.15, skinPaint);
    
    final armPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.1
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(pos.dx - scale * 0.05, pos.dy - scale * 0.12),
      Offset(pos.dx - scale * 0.3, pos.dy - scale * 0.55),
      armPaint,
    );
    canvas.drawLine(
      Offset(pos.dx + scale * 0.05, pos.dy - scale * 0.12),
      Offset(pos.dx + scale * 0.3, pos.dy - scale * 0.55),
      armPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
