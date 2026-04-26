import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

/// Navigation header with back button, progress bar, and action button
class NavigationHeader extends StatelessWidget {
  final VoidCallback? onBack;
  final double progress;
  final String? actionText;
  final VoidCallback? onAction;
  final bool showBackButton;
  final bool showProgress;
  final Color? iconColor;

  const NavigationHeader({
    super.key,
    this.onBack,
    this.progress = 0,
    this.actionText,
    this.onAction,
    this.showBackButton = true,
    this.showProgress = true,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // Back button
          if (showBackButton)
            GestureDetector(
              onTap: onBack ?? () => Navigator.of(context).pop(),
              child: Container(
                width: 40.w,
                height: 40.w,
                alignment: Alignment.center,
                child: Icon(
                  Icons.chevron_left,
                  size: 28.sp,
                  color: iconColor ?? AppTheme.darkText,
                ),
              ),
            )
          else
            SizedBox(width: 40.w),
          
          // Progress bar
          if (showProgress)
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ProgressBar(progress: progress),
              ),
            )
          else
            const Expanded(child: SizedBox()),
          
          // Action button
          if (actionText != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionText!,
                style: AppTheme.bodyTextMedium.copyWith(
                  color: iconColor ?? AppTheme.primaryPurple,
                  fontSize: 16.sp,
                ),
              ),
            )
          else
            SizedBox(width: 40.w),
        ],
      ),
    );
  }
}

/// Progress bar widget
class ProgressBar extends StatelessWidget {
  final double progress;
  final double? width;
  final double height;
  final Color backgroundColor;
  final Color fillColor;

  const ProgressBar({
    super.key,
    required this.progress,
    this.width,
    this.height = 4,
    this.backgroundColor = const Color(0xFFE8E6FF),
    this.fillColor = AppTheme.primaryPurple,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return Container(
      width: width ?? 120.w,
      height: height.h,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.r),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(fillColor),
          minHeight: height.h,
        ),
      ),
    );
  }
}

/// Step indicator text
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return Text(
      'STEP $currentStep/$totalSteps',
      style: AppTheme.stepIndicator.copyWith(fontSize: 11.sp),
    );
  }
}

/// Custom toggle switch
class CustomToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const CustomToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor = AppTheme.primaryPurple,
    this.inactiveColor = const Color(0xFFE8E6FF),
  });

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CustomToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
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
    
    return GestureDetector(
      onTap: () => widget.onChanged?.call(!widget.value),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: 51.w,
            height: 31.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: Color.lerp(widget.inactiveColor, widget.activeColor, _animation.value),
            ),
            padding: EdgeInsets.all(2.w),
            child: Align(
              alignment: Alignment.lerp(
                Alignment.centerLeft,
                Alignment.centerRight,
                _animation.value,
              )!,
              child: Container(
                width: 27.w,
                height: 27.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Custom checkbox
class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color activeColor;
  final double size;

  const CustomCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor = AppTheme.primaryPurple,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          color: value ? activeColor : Colors.transparent,
          border: Border.all(
            color: value ? activeColor : AppTheme.lightGray,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: value
            ? Icon(
                Icons.check,
                color: AppTheme.white,
                size: (size * 0.7).sp,
              )
            : null,
      ),
    );
  }
}

/// Selection circle indicator
class SelectionIndicator extends StatelessWidget {
  final bool isSelected;
  final double size;
  final Color activeColor;

  const SelectionIndicator({
    super.key,
    required this.isSelected,
    this.size = 24,
    this.activeColor = AppTheme.primaryPurple,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? activeColor : Colors.transparent,
        border: Border.all(
          color: isSelected ? activeColor : AppTheme.lightGray,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              color: AppTheme.white,
              size: (size * 0.6).sp,
            )
          : null,
    );
  }
}
