import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_keyboard.dart';

class MobileInputScreen extends StatefulWidget {
  const MobileInputScreen({super.key});

  @override
  State<MobileInputScreen> createState() => _MobileInputScreenState();
}

class _MobileInputScreenState extends State<MobileInputScreen> {
  String phoneNumber = '';
  String countryCode = '+62';
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.text != phoneNumber) {
        setState(() {
          // Filter to only digits
          phoneNumber = _controller.text.replaceAll(RegExp(r'[^0-9]'), '');
          if (phoneNumber.length > 12) {
            phoneNumber = phoneNumber.substring(0, 12);
          }
          if (_controller.text != phoneNumber) {
            _controller.text = phoneNumber;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: phoneNumber.length),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onKeyPressed(String key) {
    if (phoneNumber.length < 12) {
      setState(() {
        phoneNumber += key;
        _controller.text = phoneNumber;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: phoneNumber.length),
        );
      });
    }
  }

  void _onDelete() {
    if (phoneNumber.isNotEmpty) {
      setState(() {
        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
        _controller.text = phoneNumber;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: phoneNumber.length),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
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
              onAction: phoneNumber.length >= 8 
                  ? () => Navigator.pushNamed(context, '/otp-verification')
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        "Let's start with your\nmobile number",
                        textAlign: TextAlign.center,
                        style: AppTheme.heading2.copyWith(fontSize: 28.sp),
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Description
                    Text(
                      'Number we can use to reach you',
                      style: AppTheme.bodyText.copyWith(fontSize: 15.sp),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Phone Input
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: _buildPhoneInput(),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Verify Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: PrimaryButton(
                        text: 'Verify Now',
                        onPressed: () {
                          Navigator.pushNamed(context, '/otp-verification');
                        },
                        enabled: phoneNumber.length >= 8,
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
              onDone: phoneNumber.length >= 8 
                  ? () => Navigator.pushNamed(context, '/otp-verification')
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.borderColor, width: 1.5),
      ),
      child: Row(
        children: [
          // Country code
          GestureDetector(
            onTap: () {
              // Show country picker
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Text('🇻🇳', style: TextStyle(fontSize: 20.sp)),
                  SizedBox(width: 8.w),
                  Text(
                    countryCode,
                    style: AppTheme.bodyTextMedium.copyWith(fontSize: 16.sp),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.keyboard_arrow_down, size: 20.sp, color: AppTheme.grayText),
                ],
              ),
            ),
          ),
          
          // Divider
          Container(
            width: 1,
            height: 30.h,
            color: AppTheme.borderColor,
          ),
          
          // Phone number input - supports both custom keyboard and hardware keyboard
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12),
              ],
              style: TextStyle(
                fontSize: 16.sp,
                color: AppTheme.darkText,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your number',
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  color: AppTheme.lightGray,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
