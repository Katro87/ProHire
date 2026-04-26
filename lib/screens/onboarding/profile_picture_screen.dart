import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/custom_button.dart';

class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  int selectedAvatar = 1;
  
  final List<Map<String, dynamic>> avatars = [
    {'emoji': '🐻', 'color': const Color(0xFFFFE5D0)},
    {'emoji': '🐶', 'color': const Color(0xFFA29BFE)},
    {'emoji': '🦊', 'color': const Color(0xFFFFD5C2)},
    {'emoji': '🐱', 'color': const Color(0xFFDDD6FE)},
    {'emoji': '🐰', 'color': const Color(0xFFFFE4EC)},
    {'emoji': '🐼', 'color': const Color(0xFFE8F5E9)},
  ];

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
              onAction: () => Navigator.pushNamed(context, '/customize-interest'),
            ),
            
            SizedBox(height: 24.h),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Step Indicator
                    const StepIndicator(currentStep: 2, totalSteps: 7),
                    
                    SizedBox(height: 20.h),
                    
                    // Heading
                    Text(
                      'Profile Picture',
                      style: AppTheme.heading3.copyWith(fontSize: 24.sp),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Avatar Selector
                    _buildAvatarSelector(),
                    
                    SizedBox(height: 40.h),
                    
                    // Description
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        'You can select photo from one of\nour collection or add your own photo\nas profile picture',
                        textAlign: TextAlign.center,
                        style: AppTheme.smallText.copyWith(
                          fontSize: 14.sp,
                          height: 1.5,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Add Custom Photo
                    GestureDetector(
                      onTap: () {
                        // Open image picker
                      },
                      child: Text(
                        'Add Custom Photo',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 40.h),
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
                  Navigator.pushNamed(context, '/customize-interest');
                },
              ),
            ),
            
            SizedBox(height: Responsive.safeBottom + 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSelector() {
    return SizedBox(
      height: 200.h,
      child: Column(
        children: [
          // Up Arrow
          GestureDetector(
            onTap: () {
              setState(() {
                selectedAvatar = (selectedAvatar - 1).clamp(0, avatars.length - 1);
              });
            },
            child: Icon(
              Icons.keyboard_arrow_up,
              size: 32.sp,
              color: selectedAvatar > 0 ? AppTheme.primaryPurple : AppTheme.lightGray,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Avatar Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left Avatar
              if (selectedAvatar > 0)
                _buildAvatarItem(selectedAvatar - 1, isSmall: true, opacity: 0.5),
              if (selectedAvatar == 0)
                SizedBox(width: 80.w),
              
              SizedBox(width: 20.w),
              
              // Center Avatar (Selected)
              _buildAvatarItem(selectedAvatar, isSmall: false, isSelected: true),
              
              SizedBox(width: 20.w),
              
              // Right Avatar
              if (selectedAvatar < avatars.length - 1)
                _buildAvatarItem(selectedAvatar + 1, isSmall: true, opacity: 0.5),
              if (selectedAvatar == avatars.length - 1)
                SizedBox(width: 80.w),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Down Arrow
          GestureDetector(
            onTap: () {
              setState(() {
                selectedAvatar = (selectedAvatar + 1).clamp(0, avatars.length - 1);
              });
            },
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 32.sp,
              color: selectedAvatar < avatars.length - 1 ? AppTheme.primaryPurple : AppTheme.lightGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarItem(int index, {bool isSmall = false, bool isSelected = false, double opacity = 1.0}) {
    final avatar = avatars[index];
    final size = isSmall ? 80.w : 120.w;
    
    return GestureDetector(
      onTap: () => setState(() => selectedAvatar = index),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: opacity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: avatar['color'],
            shape: BoxShape.circle,
            border: isSelected 
                ? Border.all(color: AppTheme.primaryPurple, width: 4)
                : null,
            boxShadow: isSelected ? AppTheme.selectedCardShadow : null,
          ),
          child: Center(
            child: Text(
              avatar['emoji'],
              style: TextStyle(fontSize: isSmall ? 32.sp : 48.sp),
            ),
          ),
        ),
      ),
    );
  }
}
