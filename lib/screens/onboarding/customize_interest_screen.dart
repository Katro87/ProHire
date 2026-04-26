import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/custom_button.dart';

class CustomizeInterestScreen extends StatefulWidget {
  const CustomizeInterestScreen({super.key});

  @override
  State<CustomizeInterestScreen> createState() => _CustomizeInterestScreenState();
}

class _CustomizeInterestScreenState extends State<CustomizeInterestScreen> {
  Set<int> selectedInterests = {};

  final List<Map<String, dynamic>> interests = [
    {'emoji': '🍊', 'label': 'Nutrition', 'color': AppTheme.nutritionBg},
    {'emoji': '🍌', 'label': 'Organic', 'color': AppTheme.organicBg},
    {'emoji': '🥗', 'label': 'Meditation', 'color': AppTheme.meditationBg},
    {'emoji': '🏃', 'label': 'Sports', 'color': AppTheme.sportsBg},
    {'emoji': '🚭', 'label': 'Smoke Free', 'color': AppTheme.smokeBg},
    {'emoji': '😴', 'label': 'Sleep', 'color': AppTheme.sleepBg},
    {'emoji': '🥕', 'label': 'Health', 'color': AppTheme.healthBg},
    {'emoji': '🏃‍♂️', 'label': 'Running', 'color': AppTheme.runningBg},
    {'emoji': '🥑', 'label': 'Vegan', 'color': AppTheme.veganBg},
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
              progress: 3 / 7,
              actionText: 'Skip',
              onAction: () => Navigator.pushNamed(context, '/set-goals'),
            ),
            
            SizedBox(height: 24.h),
            
            // Step Indicator
            const StepIndicator(currentStep: 3, totalSteps: 7),
            
            SizedBox(height: 20.h),
            
            // Heading
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'Time to customize\nyour interest',
                textAlign: TextAlign.center,
                style: AppTheme.heading3.copyWith(fontSize: 24.sp, height: 1.3),
              ),
            ),
            
            SizedBox(height: 40.h),
            
            // Interest Grid
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: _buildInterestGrid(),
              ),
            ),
            
            // Continue Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: PrimaryButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.pushNamed(context, '/set-goals');
                },
                enabled: selectedInterests.isNotEmpty,
              ),
            ),
            
            SizedBox(height: Responsive.safeBottom + 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.gridColumns,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1,
      ),
      itemCount: interests.length,
      itemBuilder: (context, index) {
        final interest = interests[index];
        final isSelected = selectedInterests.contains(index);
        
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedInterests.remove(index);
              } else {
                selectedInterests.add(index);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: interest['color'],
              borderRadius: BorderRadius.circular(24.r),
              border: isSelected 
                  ? Border.all(color: AppTheme.primaryPurple, width: 3)
                  : null,
              boxShadow: isSelected 
                  ? AppTheme.selectedCardShadow 
                  : AppTheme.cardShadow,
            ),
            child: Stack(
              children: [
                // Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        interest['emoji'],
                        style: TextStyle(fontSize: 36.sp),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        interest['label'],
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Selection indicator
                if (isSelected)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 14.sp,
                        color: AppTheme.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
