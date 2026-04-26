import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import 'dart:math' as math;

/// Animated illustration widget with various types
class IllustrationWidget extends StatefulWidget {
  final IllustrationType type;
  final double? width;
  final double? height;
  final bool animate;

  const IllustrationWidget({
    super.key,
    required this.type,
    this.width,
    this.height,
    this.animate = true,
  });

  @override
  State<IllustrationWidget> createState() => _IllustrationWidgetState();
}

class _IllustrationWidgetState extends State<IllustrationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, widget.animate ? _floatAnimation.value : 0),
          child: SizedBox(
            width: widget.width ?? 280.w,
            height: widget.height ?? 240.h,
            child: CustomPaint(
              painter: _IllustrationPainter(widget.type),
            ),
          ),
        );
      },
    );
  }
}

enum IllustrationType {
  welcome,
  fingerprint,
  profile,
  gender,
  fitness,
  notification,
  weight,
  podcast,
  nightSky,
  success,
}

class _IllustrationPainter extends CustomPainter {
  final IllustrationType type;

  _IllustrationPainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case IllustrationType.welcome:
        _drawWelcomeIllustration(canvas, size);
        break;
      case IllustrationType.fingerprint:
        _drawFingerprintIllustration(canvas, size);
        break;
      case IllustrationType.profile:
        _drawProfileIllustration(canvas, size);
        break;
      case IllustrationType.gender:
        _drawGenderIllustration(canvas, size);
        break;
      case IllustrationType.fitness:
        _drawFitnessIllustration(canvas, size);
        break;
      case IllustrationType.notification:
        _drawNotificationIllustration(canvas, size);
        break;
      case IllustrationType.weight:
        _drawWeightIllustration(canvas, size);
        break;
      case IllustrationType.podcast:
        _drawPodcastIllustration(canvas, size);
        break;
      case IllustrationType.nightSky:
        _drawNightSkyIllustration(canvas, size);
        break;
      case IllustrationType.success:
        _drawSuccessIllustration(canvas, size);
        break;
    }
  }


  void _drawWelcomeIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background circle
    final bgPaint = Paint()
      ..color = AppTheme.pastelPurple
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.4, bgPaint);
    
    // Person body
    final bodyPaint = Paint()
      ..color = AppTheme.primaryPurple
      ..style = PaintingStyle.fill;
    
    // Draw stylized person doing yoga
    final path = Path();
    path.moveTo(center.dx, center.dy - 60);
    path.quadraticBezierTo(center.dx + 40, center.dy - 40, center.dx + 60, center.dy);
    path.quadraticBezierTo(center.dx + 40, center.dy + 60, center.dx, center.dy + 40);
    path.quadraticBezierTo(center.dx - 40, center.dy + 60, center.dx - 60, center.dy);
    path.quadraticBezierTo(center.dx - 40, center.dy - 40, center.dx, center.dy - 60);
    canvas.drawPath(path, bodyPaint);
    
    // Head
    final headPaint = Paint()
      ..color = const Color(0xFFFFD5C2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx, center.dy - 80), 25, headPaint);
    
    // Decorative elements
    final decorPaint = Paint()
      ..color = AppTheme.pastelPink
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - 80, center.dy - 60), 15, decorPaint);
    canvas.drawCircle(Offset(center.dx + 80, center.dy + 40), 12, decorPaint);
    canvas.drawCircle(Offset(center.dx - 60, center.dy + 70), 10, decorPaint);
  }

  void _drawPhoneIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background
    final bgPaint = Paint()
      ..color = AppTheme.pastelBlue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.38, bgPaint);
    
    // Phone body
    final phonePaint = Paint()
      ..color = AppTheme.textPrimary
      ..style = PaintingStyle.fill;
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 80, height: 140),
      const Radius.circular(12),
    );
    canvas.drawRRect(phoneRect, phonePaint);
    
    // Screen
    final screenPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 70, height: 120),
      const Radius.circular(8),
    );
    canvas.drawRRect(screenRect, screenPaint);
    
    // Signal waves
    final wavePaint = Paint()
      ..color = AppTheme.primaryPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    for (int i = 1; i <= 3; i++) {
      canvas.drawArc(
        Rect.fromCenter(center: Offset(center.dx + 50, center.dy - 50), width: 20.0 * i, height: 20.0 * i),
        -0.8,
        1.6,
        false,
        wavePaint,
      );
    }
  }

  void _drawOtpIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    final bgPaint = Paint()
      ..color = AppTheme.pastelGreen
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.38, bgPaint);
    
    // Envelope
    final envPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final envPath = Path();
    envPath.moveTo(center.dx - 60, center.dy - 30);
    envPath.lineTo(center.dx + 60, center.dy - 30);
    envPath.lineTo(center.dx + 60, center.dy + 40);
    envPath.lineTo(center.dx - 60, center.dy + 40);
    envPath.close();
    canvas.drawPath(envPath, envPaint);
    
    // Envelope flap
    final flapPaint = Paint()
      ..color = AppTheme.primaryPurple
      ..style = PaintingStyle.fill;
    final flapPath = Path();
    flapPath.moveTo(center.dx - 60, center.dy - 30);
    flapPath.lineTo(center.dx, center.dy + 10);
    flapPath.lineTo(center.dx + 60, center.dy - 30);
    flapPath.close();
    canvas.drawPath(flapPath, flapPaint);
    
    // Stars
    final starPaint = Paint()
      ..color = AppTheme.pastelYellow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - 70, center.dy - 50), 8, starPaint);
    canvas.drawCircle(Offset(center.dx + 70, center.dy + 50), 6, starPaint);
  }

  void _drawPasswordIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    final bgPaint = Paint()
      ..color = AppTheme.pastelOrange
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.38, bgPaint);
    
    // Lock body
    final lockPaint = Paint()
      ..color = AppTheme.primaryPurple
      ..style = PaintingStyle.fill;
    final lockRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 20), width: 70, height: 60),
      const Radius.circular(8),
    );
    canvas.drawRRect(lockRect, lockPaint);
    
    // Lock shackle
    final shacklePaint = Paint()
      ..color = AppTheme.primaryPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx, center.dy - 10), width: 40, height: 50),
      3.14,
      3.14,
      false,
      shacklePaint,
    );
    
    // Keyhole
    final keyholePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx, center.dy + 15), 10, keyholePaint);
    canvas.drawRect(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 30), width: 8, height: 15),
      keyholePaint,
    );
  }

  void _drawFingerprintIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    final bgPaint = Paint()
      ..color = AppTheme.pastelPink
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.38, bgPaint);
    
    // Fingerprint pattern
    final fpPaint = Paint()
      ..color = AppTheme.primaryPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    for (int i = 1; i <= 5; i++) {
      canvas.drawArc(
        Rect.fromCenter(center: center, width: 20.0 * i, height: 30.0 * i),
        0.5,
        2.0,
        false,
        fpPaint,
      );
    }
    
    // Phone outline
    final phonePaint = Paint()
      ..color = AppTheme.textPrimary.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 120, height: 180),
      const Radius.circular(16),
    );
    canvas.drawRRect(phoneRect, phonePaint);
  }

  void _drawProfileIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    final bgPaint = Paint()
      ..color = AppTheme.pastelPurple
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.38, bgPaint);
    
    // Avatar circle
    final avatarBg = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 50, avatarBg);
    
    // Person silhouette
    final personPaint = Paint()
      ..color = AppTheme.primaryPurpleLight
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx, center.dy - 15), 20, personPaint);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 30), width: 50, height: 40),
      3.14,
      3.14,
      false,
      personPaint,
    );
    
    // Camera icon
    final camPaint = Paint()
      ..color = AppTheme.primaryPurple
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx + 35, center.dy + 35), 15, camPaint);
  }

  void _drawInterestsIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    final bgPaint = Paint()
      ..color = AppTheme.pastelBlue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.38, bgPaint);
    
    // Interest bubbles
    final colors = [
      AppTheme.pastelPink,
      AppTheme.pastelGreen,
      AppTheme.pastelYellow,
      AppTheme.pastelOrange,
      AppTheme.pastelPurple,
    ];
    
    final positions = [
      Offset(center.dx - 50, center.dy - 40),
      Offset(center.dx + 40, center.dy - 30),
      Offset(center.dx - 30, center.dy + 30),
      Offset(center.dx + 50, center.dy + 40),
      Offset(center.dx, center.dy),
    ];
    
    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;
      canvas.drawCircle(positions[i], 25 + (i * 3), paint);
    }
  }

  void _drawPreferencesIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    final bgPaint = Paint()
      ..color = AppTheme.pastelGreen
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.38, bgPaint);
    
    // Settings gear
    final gearPaint = Paint()
      ..color = AppTheme.primaryPurple
      ..style = PaintingStyle.fill;
    
    // Main circle
    canvas.drawCircle(center, 40, gearPaint);
    
    // Gear teeth
    for (int i = 0; i < 8; i++) {
      final angle = (i * 3.14159 * 2) / 8;
      final x = center.dx + 50 * _cos(angle);
      final y = center.dy + 50 * _sin(angle);
      canvas.drawCircle(Offset(x, y), 12, gearPaint);
    }
    
    // Inner circle
    final innerPaint = Paint()
      ..color = AppTheme.pastelGreen
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 20, innerPaint);
  }

  double _cos(double x) {
    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  double _sin(double x) {
    double result = x;
    double term = x;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }

  void _drawGenderIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    final bgPaint = Paint()
      ..color = AppTheme.pastelPink
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.38, bgPaint);
    
    // Male symbol
    final malePaint = Paint()
      ..color = AppTheme.primaryPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(Offset(center.dx - 40, center.dy), 25, malePaint);
    canvas.drawLine(
      Offset(center.dx - 22, center.dy - 18),
      Offset(center.dx - 5, center.dy - 35),
      malePaint,
    );
    
    // Female symbol
    final femalePaint = Paint()
      ..color = AppTheme.pastelPurple.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(Offset(center.dx + 40, center.dy - 10), 25, femalePaint);
    canvas.drawLine(
      Offset(center.dx + 40, center.dy + 15),
      Offset(center.dx + 40, center.dy + 45),
      femalePaint,
    );
    canvas.drawLine(
      Offset(center.dx + 25, center.dy + 30),
      Offset(center.dx + 55, center.dy + 30),
      femalePaint,
    );
  }

  void _drawFitnessIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    final bgPaint = Paint()
      ..color = AppTheme.pastelOrange
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.38, bgPaint);
    
    // Dumbbell
    final barPaint = Paint()
      ..color = AppTheme.textPrimary
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(center: center, width: 100, height: 12),
      barPaint,
    );
    
    // Weights
    final weightPaint = Paint()
      ..color = AppTheme.primaryPurple
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx - 45, center.dy), width: 25, height: 50),
        const Radius.circular(4),
      ),
      weightPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx + 45, center.dy), width: 25, height: 50),
        const Radius.circular(4),
      ),
      weightPaint,
    );
    
    // Sparkles
    final sparklePaint = Paint()
      ..color = AppTheme.pastelYellow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - 70, center.dy - 40), 8, sparklePaint);
    canvas.drawCircle(Offset(center.dx + 70, center.dy + 40), 6, sparklePaint);
  }

  void _drawNotificationIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    final bgPaint = Paint()
      ..color = AppTheme.pastelYellow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.38, bgPaint);
    
    // Bell
    final bellPaint = Paint()
      ..color = AppTheme.primaryPurple
      ..style = PaintingStyle.fill;
    
    final bellPath = Path();
    bellPath.moveTo(center.dx - 35, center.dy + 20);
    bellPath.quadraticBezierTo(center.dx - 35, center.dy - 40, center.dx, center.dy - 50);
    bellPath.quadraticBezierTo(center.dx + 35, center.dy - 40, center.dx + 35, center.dy + 20);
    bellPath.lineTo(center.dx - 35, center.dy + 20);
    canvas.drawPath(bellPath, bellPaint);
    
    // Bell bottom
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 20), width: 90, height: 25),
      0,
      3.14,
      false,
      bellPaint,
    );
    
    // Bell clapper
    canvas.drawCircle(Offset(center.dx, center.dy + 35), 8, bellPaint);
    
    // Notification dot
    final dotPaint = Paint()
      ..color = AppTheme.error
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx + 25, center.dy - 35), 10, dotPaint);
  }

  void _drawWeightIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    final bgPaint = Paint()
      ..color = AppTheme.pastelBlue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.38, bgPaint);
    
    // Scale base
    final scalePaint = Paint()
      ..color = AppTheme.primaryPurple
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy + 30), width: 100, height: 20),
        const Radius.circular(10),
      ),
      scalePaint,
    );
    
    // Scale top
    final topPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy), width: 80, height: 60),
        const Radius.circular(12),
      ),
      topPaint,
    );
    
    // Display
    final displayPaint = Paint()
      ..color = AppTheme.primaryPurpleLight.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy), width: 50, height: 25),
        const Radius.circular(4),
      ),
      displayPaint,
    );
  }

  void _drawSuccessIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    final bgPaint = Paint()
      ..color = AppTheme.pastelGreen
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.38, bgPaint);
    
    // Checkmark circle
    final circlePaint = Paint()
      ..color = AppTheme.success
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 50, circlePaint);
    
    // Checkmark
    final checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    
    final checkPath = Path();
    checkPath.moveTo(center.dx - 20, center.dy);
    checkPath.lineTo(center.dx - 5, center.dy + 15);
    checkPath.lineTo(center.dx + 20, center.dy - 15);
    canvas.drawPath(checkPath, checkPaint);
    
    // Celebration stars
    final starPaint = Paint()
      ..color = AppTheme.pastelYellow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - 70, center.dy - 50), 10, starPaint);
    canvas.drawCircle(Offset(center.dx + 70, center.dy - 40), 8, starPaint);
    canvas.drawCircle(Offset(center.dx + 60, center.dy + 60), 12, starPaint);
    canvas.drawCircle(Offset(center.dx - 60, center.dy + 50), 6, starPaint);
  }

  void _drawPodcastIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    final bgPaint = Paint()
      ..color = AppTheme.pastelPurple
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.38, bgPaint);
    
    // Microphone
    final micPaint = Paint()
      ..color = AppTheme.primaryPurple
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy - 20), width: 40, height: 70),
        const Radius.circular(20),
      ),
      micPaint,
    );
    
    // Stand
    final standPaint = Paint()
      ..color = AppTheme.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawLine(
      Offset(center.dx, center.dy + 15),
      Offset(center.dx, center.dy + 50),
      standPaint,
    );
    canvas.drawLine(
      Offset(center.dx - 25, center.dy + 50),
      Offset(center.dx + 25, center.dy + 50),
      standPaint,
    );
    
    // Sound waves
    final wavePaint = Paint()
      ..color = AppTheme.primaryPurpleLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    for (int i = 1; i <= 3; i++) {
      canvas.drawArc(
        Rect.fromCenter(center: Offset(center.dx + 35, center.dy - 20), width: 15.0 * i, height: 40.0 * i),
        -0.8,
        1.6,
        false,
        wavePaint,
      );
      canvas.drawArc(
        Rect.fromCenter(center: Offset(center.dx - 35, center.dy - 20), width: 15.0 * i, height: 40.0 * i),
        2.3,
        1.6,
        false,
        wavePaint,
      );
    }
  }

  void _drawNightSkyIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Background circle (night sky)
    final bgPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.4, bgPaint);
    
    // Moon
    final moonPaint = Paint()
      ..color = const Color(0xFFF5F5DC)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx + 30, center.dy - 30), 25, moonPaint);
    
    // Stars
    final starPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final starPositions = [
      Offset(center.dx - 50, center.dy - 40),
      Offset(center.dx - 30, center.dy + 20),
      Offset(center.dx + 50, center.dy + 30),
      Offset(center.dx - 60, center.dy + 50),
      Offset(center.dx + 20, center.dy - 50),
    ];
    
    for (var pos in starPositions) {
      canvas.drawCircle(pos, 3, starPaint);
    }
    
    // Decorative elements
    final decorPaint = Paint()
      ..color = AppTheme.pastelPurple.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - 80, center.dy), 10, decorPaint);
    canvas.drawCircle(Offset(center.dx + 80, center.dy + 20), 8, decorPaint);
  }

  void _drawMeditationIllustration(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    final bgPaint = Paint()
      ..color = AppTheme.pastelPink
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.38, bgPaint);
    
    // Person meditating
    final bodyPaint = Paint()
      ..color = AppTheme.primaryPurple
      ..style = PaintingStyle.fill;
    
    // Body
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 20), width: 60, height: 40),
      bodyPaint,
    );
    
    // Head
    final headPaint = Paint()
      ..color = const Color(0xFFFFD5C2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx, center.dy - 30), 25, headPaint);
    
    // Hair
    final hairPaint = Paint()
      ..color = AppTheme.textPrimary
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx, center.dy - 40), width: 50, height: 40),
      3.14,
      3.14,
      false,
      hairPaint,
    );
    
    // Aura circles
    final auraPaint = Paint()
      ..color = AppTheme.primaryPurpleLight.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, 60 + (i * 15), auraPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
