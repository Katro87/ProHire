import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_keyboard.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  List<String> otpDigits = ['', '', '', '', '', ''];
  int currentIndex = 0;
  int resendTimer = 30;
  Timer? _timer;
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer > 0) {
        setState(() => resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  void _onKeyPressed(String key) {
    if (currentIndex < 6) {
      setState(() {
        otpDigits[currentIndex] = key;
        _controllers[currentIndex].text = key;
        currentIndex++;
        if (currentIndex < 6) {
          _focusNodes[currentIndex].requestFocus();
        }
      });
    }
  }

  void _onDelete() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        otpDigits[currentIndex] = '';
        _controllers[currentIndex].clear();
        _focusNodes[currentIndex].requestFocus();
      });
    }
  }

  void _handleTextInput(int index, String value) {
    if (value.isNotEmpty) {
      // Filter to only digits
      String digit = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (digit.isNotEmpty) {
        setState(() {
          otpDigits[index] = digit[digit.length - 1];
          _controllers[index].text = otpDigits[index];
          if (index < 5) {
            currentIndex = index + 1;
            _focusNodes[index + 1].requestFocus();
          } else {
            currentIndex = 6;
          }
        });
      }
    }
  }

  void _handleKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
      if (otpDigits[index].isEmpty && index > 0) {
        setState(() {
          currentIndex = index - 1;
          otpDigits[currentIndex] = '';
          _controllers[currentIndex].clear();
          _focusNodes[currentIndex].requestFocus();
        });
      } else if (otpDigits[index].isNotEmpty) {
        setState(() {
          otpDigits[index] = '';
          _controllers[index].clear();
          currentIndex = index;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    final isComplete = otpDigits.every((d) => d.isNotEmpty);
    
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            
            // Navigation Header
            NavigationHeader(
              progress: 1 / 7,
              actionText: 'Next',
              onAction: isComplete 
                  ? () => Navigator.pushNamed(context, '/set-password')
                  : null,
            ),
            
            SizedBox(height: 24.h),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Step Indicator
                    const StepIndicator(currentStep: 1, totalSteps: 7),
                    
                    SizedBox(height: 30.h),
                    
                    // Heading
                    Text(
                      'Verify your number',
                      textAlign: TextAlign.center,
                      style: AppTheme.heading2.copyWith(fontSize: 28.sp),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Description
                    Text(
                      "We'll text you on 08225780727",
                      style: AppTheme.bodyText.copyWith(fontSize: 15.sp),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // OTP Input
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: _buildOtpInputs(),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Resend Link
                    GestureDetector(
                      onTap: resendTimer == 0 ? () {
                        setState(() => resendTimer = 30);
                        _startResendTimer();
                      } : null,
                      child: Text(
                        resendTimer > 0 
                            ? 'Resend code in ${resendTimer}s'
                            : 'Send me a new code',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: resendTimer > 0 ? AppTheme.grayText : AppTheme.primaryPurple,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Continue Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: PrimaryButton(
                        text: 'Continue',
                        onPressed: () {
                          Navigator.pushNamed(context, '/set-password');
                        },
                        enabled: isComplete,
                      ),
                    ),
                    
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
            
            // Number Pad - always show with toggle
            NumberKeyboard(
              onKeyPressed: _onKeyPressed,
              onDelete: _onDelete,
              initiallyExpanded: true,
              onDone: isComplete 
                  ? () => Navigator.pushNamed(context, '/set-password')
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpInputs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final isFilled = otpDigits[index].isNotEmpty;
        final isActive = index == currentIndex;
        
        return Container(
          width: 48.w,
          height: 48.w,
          margin: EdgeInsets.symmetric(horizontal: 6.w),
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _handleKeyEvent(index, event),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: isFilled ? AppTheme.softPurpleBackground : AppTheme.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: isActive ? AppTheme.primaryPurple : AppTheme.borderColor,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: isFilled ? AppTheme.primaryPurple.withAlpha(100) : AppTheme.borderColor,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppTheme.primaryPurple,
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: (value) => _handleTextInput(index, value),
              onTap: () {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
        );
      }),
    );
  }
}
