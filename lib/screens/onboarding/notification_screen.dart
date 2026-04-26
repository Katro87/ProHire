import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/custom_button.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _bellController;
  
  Map<String, bool> notifications = {
    'Daily Reminders': true,
    'Workout Notifications': true,
    'Progress Updates': false,
    'New Content Alerts': true,
    'Community Messages': false,
  };

  final Map<String, IconData> notificationIcons = {
    'Daily Reminders': Icons.alarm_outlined,
    'Workout Notifications': Icons.fitness_center_outlined,
    'Progress Updates': Icons.trending_up_outlined,
    'New Content Alerts': Icons.auto_awesome_outlined,
    'Community Messages': Icons.people_outline,
  };

  final Map<String, String> notificationDescriptions = {
    'Daily Reminders': 'Get reminded to stay on track',
    'Workout Notifications': 'Alerts when it\'s time to exercise',
    'Progress Updates': 'Weekly summary of your progress',
    'New Content Alerts': 'Updates about new features & content',
    'Community Messages': 'Messages from the community',
  };

  @override
  void initState() {
    super.initState();
    _bellController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bellController.dispose();
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
              progress: 7 / 7,
              actionText: 'Skip',
              onAction: () => Navigator.pushNamed(context, '/weight'),
            ),
            
            SizedBox(height: 24.h),
            
            // Step Indicator
            const StepIndicator(currentStep: 7, totalSteps: 7),
            
            SizedBox(height: 20.h),
            
            // Bell Illustration
            AnimatedBuilder(
              animation: _bellController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: (_bellController.value - 0.5) * 0.2,
                  child: child,
                );
              },
              child: _buildBellIllustration(),
            ),
            
            SizedBox(height: 24.h),
            
            // Heading
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'Never miss a beat!',
                textAlign: TextAlign.center,
                style: AppTheme.heading3.copyWith(fontSize: 24.sp, height: 1.3),
              ),
            ),
            
            SizedBox(height: 8.h),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'Choose what notifications you\'d like to receive',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.grayText,
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Notification Options
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: notifications.entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _buildNotificationOption(
                        entry.key,
                        notificationDescriptions[entry.key]!,
                        notificationIcons[entry.key]!,
                        entry.value,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            // Continue Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: PrimaryButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.pushNamed(context, '/weight');
                },
              ),
            ),
            
            SizedBox(height: Responsive.safeBottom + 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBellIllustration() {
    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: AppTheme.buttonShadow,
      ),
      child: Icon(
        Icons.notifications_active_outlined,
        size: 48.sp,
        color: AppTheme.white,
      ),
    );
  }

  Widget _buildNotificationOption(
    String title,
    String description,
    IconData icon,
    bool isEnabled,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          notifications[title] = !notifications[title]!;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isEnabled ? AppTheme.softPurpleBg : AppTheme.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isEnabled ? AppTheme.primaryPurple : AppTheme.borderLight,
            width: isEnabled ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: isEnabled ? AppTheme.primaryPurple : AppTheme.lightGray,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: isEnabled ? AppTheme.white : AppTheme.grayText,
              ),
            ),
            
            SizedBox(width: 12.w),
            
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkText,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.grayText,
                    ),
                  ),
                ],
              ),
            ),
            
            // Checkbox
            CustomCheckbox(
              value: isEnabled,
              onChanged: (value) {
                setState(() {
                  notifications[title] = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
