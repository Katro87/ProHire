import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_keyboard.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  String password = '';
  bool obscurePassword = true;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  bool get has8Chars => password.length >= 8;
  bool get hasUppercase => password.contains(RegExp(r'[A-Z]'));
  bool get hasSymbol => password.contains(RegExp(r"[!@#$%^&*(),.?:{}|<>\-_=+\[\]\\;'`~]"));
  bool get hasNumber => password.contains(RegExp(r'[0-9]'));
  bool get isValid => has8Chars && hasUppercase && hasSymbol && hasNumber;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.text != password) {
        setState(() {
          password = _controller.text;
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
    setState(() {
      password += key;
      _controller.text = password;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: password.length),
      );
    });
  }

  void _onDelete() {
    if (password.isNotEmpty) {
      setState(() {
        password = password.substring(0, password.length - 1);
        _controller.text = password;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: password.length),
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
              onAction: isValid 
                  ? () => Navigator.pushNamed(context, '/enable-fingerprint')
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
                      'Set your password',
                      style: AppTheme.heading2.copyWith(fontSize: 28.sp),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Password Input Field (for hardware keyboard support)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: _buildPasswordInput(),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Requirements
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: _buildRequirements(),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Continue Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: PrimaryButton(
                        text: 'Continue',
                        onPressed: () {
                          Navigator.pushNamed(context, '/enable-fingerprint');
                        },
                        enabled: isValid,
                      ),
                    ),
                    
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
            
            // Full Keyboard - always show with toggle
            CustomKeyboard(
              onKeyPressed: _onKeyPressed,
              onDelete: _onDelete,
              showNumbersOnly: false,
              initiallyExpanded: true,
              onDone: isValid 
                  ? () => Navigator.pushNamed(context, '/enable-fingerprint')
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.borderColor, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              obscureText: obscurePassword,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppTheme.darkText,
                letterSpacing: obscurePassword ? 4 : 0,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your password',
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  color: AppTheme.lightGray,
                  letterSpacing: 0,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => obscurePassword = !obscurePassword),
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
                size: 20.sp,
                color: AppTheme.grayText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirements() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRequirement('8+ characters', has8Chars),
            SizedBox(height: 8.h),
            _buildRequirement('1 symbol', hasSymbol),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRequirement('1 uppercase', hasUppercase),
            SizedBox(height: 8.h),
            _buildRequirement('1 number', hasNumber),
          ],
        ),
      ],
    );
  }

  Widget _buildRequirement(String text, bool met) {
    return Row(
      children: [
        Icon(
          met ? Icons.check : Icons.close,
          size: 14.sp,
          color: met ? AppTheme.successGreen : AppTheme.coralPink,
        ),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppTheme.grayText,
            decoration: met ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}
