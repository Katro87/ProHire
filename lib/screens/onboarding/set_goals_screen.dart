import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/custom_button.dart';

class SetGoalsScreen extends StatefulWidget {
  const SetGoalsScreen({super.key});

  @override
  State<SetGoalsScreen> createState() => _SetGoalsScreenState();
}

class _SetGoalsScreenState extends State<SetGoalsScreen> {
  Map<String, bool> goals = {
    'Weight Loss': false,
    'Better Sleep': true,
    'Track Nutrition': false,
    'Improve Fitness': true,
  };

  final Map<String, IconData> goalIcons = {
    'Weight Loss': Icons.monitor_weight_outlined,
    'Better Sleep': Icons.nightlight_round_outlined,
    'Track Nutrition': Icons.restaurant_menu_outlined,
    'Improve Fitness': Icons.fitness_center_outlined,
  };

  final Map<String, String> goalDescriptions = {
    'Weight Loss': 'Track calories and reach your ideal weight',
    'Better Sleep': 'Improve sleep quality with guided sessions',
    'Track Nutrition': 'Monitor your daily food intake',
    'Improve Fitness': 'Build strength and endurance',
  };

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
              progress: 4 / 7,
              actionText: 'Skip',
              onAction: () => Navigator.pushNamed(context, '/gender'),
            ),
            
            SizedBox(height: 24.h),
            
            // Step Indicator
            const StepIndicator(currentStep: 4, totalSteps: 7),
            
            SizedBox(height: 20.h),
            
            // Heading
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'Let\'s set your goals\ntogether',
                textAlign: TextAlign.center,
                style: AppTheme.heading3.copyWith(fontSize: 24.sp, height: 1.3),
              ),
            ),
            
            SizedBox(height: 8.h),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'Select the goals you want to achieve',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.grayText,
                ),
              ),
            ),
            
            SizedBox(height: 32.h),
            
            // Goal Cards
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: goals.entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: _buildGoalCard(
                        entry.key,
                        goalDescriptions[entry.key]!,
                        goalIcons[entry.key]!,
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
                  Navigator.pushNamed(context, '/gender');
                },
                enabled: goals.values.any((v) => v),
              ),
            ),
            
            SizedBox(height: Responsive.safeBottom + 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(String title, String description, IconData icon, bool isEnabled) {
    return GestureDetector(
      onTap: () {
        setState(() {
          goals[title] = !goals[title]!;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isEnabled ? AppTheme.softPurpleBg : AppTheme.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isEnabled ? AppTheme.primaryPurple : AppTheme.borderLight,
            width: isEnabled ? 2 : 1,
          ),
          boxShadow: isEnabled ? AppTheme.selectedCardShadow : AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: isEnabled ? AppTheme.primaryPurple : AppTheme.softPurpleBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: isEnabled ? AppTheme.white : AppTheme.primaryPurple,
                size: 24.sp,
              ),
            ),
            
            SizedBox(width: 16.w),
            
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkText,
                    ),
                  ),
                  SizedBox(height: 4.h),
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
            
            // Toggle
            CustomToggle(
              value: isEnabled,
              onChanged: (value) {
                setState(() {
                  goals[title] = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
