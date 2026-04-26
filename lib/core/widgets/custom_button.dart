import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Primary gradient button with shadow and animations
class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final bool enabled;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.enabled = true,
    this.icon,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enabled && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    final isEnabled = widget.enabled && !widget.isLoading;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: isEnabled ? widget.onPressed : null,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isEnabled ? 1.0 : 0.5,
              child: Container(
                width: widget.width ?? Responsive.maxContentWidth(),
                height: widget.height ?? 56.h,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(28.r),
                  boxShadow: isEnabled ? AppTheme.buttonShadow : null,
                ),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                              SizedBox(width: 8.w),
                            ],
                            Text(
                              widget.text,
                              style: AppTheme.buttonText.copyWith(
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Secondary text button
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: AppTheme.linkText.copyWith(
          color: color ?? AppTheme.primaryPurple,
          fontSize: 16.sp,
        ),
      ),
    );
  }
}

/// Small pill button
class PillButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double? width;

  const PillButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = AppTheme.white,
    this.textColor = AppTheme.primaryPurple,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          text,
          style: AppTheme.buttonText.copyWith(
            color: textColor,
            fontSize: 15.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

