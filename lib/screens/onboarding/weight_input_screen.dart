import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/custom_button.dart';

class WeightInputScreen extends StatefulWidget {
  const WeightInputScreen({super.key});

  @override
  State<WeightInputScreen> createState() => _WeightInputScreenState();
}

class _WeightInputScreenState extends State<WeightInputScreen> {
  double weight = 65.0;
  bool isKg = true;
  
  double get displayWeight => isKg ? weight : weight * 2.20462;
  String get unit => isKg ? 'kg' : 'lbs';
  double get minWeight => isKg ? 30.0 : 66.0;
  double get maxWeight => isKg ? 200.0 : 440.0;

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return Scaffold(
      backgroundColor: AppTheme.softPurpleBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.only(bottom: Responsive.safeBottom + 20.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top section
                      Column(
                        children: [
                          SizedBox(height: 16.h),
                          
                          // Navigation Header
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    width: 40.w,
                                    height: 40.w,
                                    decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: 20.sp,
                                      color: AppTheme.darkText,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pushNamed(context, '/podcasts'),
                                  child: Text(
                                    'Skip',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppTheme.primaryPurple,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 24.h),
                          
                          // Heading
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Text(
                              'What is your weight?',
                              textAlign: TextAlign.center,
                              style: AppTheme.heading3.copyWith(fontSize: 24.sp, height: 1.3),
                            ),
                          ),
                          
                          SizedBox(height: 8.h),
                          
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Text(
                              'This helps us calculate your fitness metrics',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppTheme.grayText,
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 24.h),
                          
                          // Unit Toggle
                          _buildUnitToggle(),
                        ],
                      ),
                      
                      // Weight Display Card
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                        padding: EdgeInsets.all(24.w),
                        constraints: BoxConstraints(
                          maxHeight: (constraints.maxHeight * 0.45).clamp(280.0, 400.0),
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(32.r),
                          boxShadow: AppTheme.cardShadow,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Scale Illustration
                            _buildScaleIllustration(),
                            
                            SizedBox(height: 24.h),
                            
                            // Weight Value
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  displayWeight.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 48.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryPurple,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  unit,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.grayText,
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 24.h),
                            
                            // Slider
                            _buildWeightSlider(),
                            
                            SizedBox(height: 12.h),
                            
                            // Min/Max labels
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${minWeight.toInt()} $unit',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppTheme.grayText,
                                    ),
                                  ),
                                  Text(
                                    '${maxWeight.toInt()} $unit',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppTheme.grayText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Continue Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: PrimaryButton(
                          text: 'Continue',
                          onPressed: () {
                            Navigator.pushNamed(context, '/podcasts');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUnitToggle() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildUnitButton('kg', isKg),
          _buildUnitButton('lbs', !isKg),
        ],
      ),
    );
  }

  Widget _buildUnitButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isKg = text == 'kg';
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppTheme.white : AppTheme.grayText,
          ),
        ),
      ),
    );
  }

  Widget _buildScaleIllustration() {
    return Container(
      width: 70.w,
      height: 70.w,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: AppTheme.buttonShadow,
      ),
      child: Icon(
        Icons.monitor_weight_outlined,
        size: 36.sp,
        color: AppTheme.white,
      ),
    );
  }

  Widget _buildWeightSlider() {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 8.h,
        activeTrackColor: AppTheme.primaryPurple,
        inactiveTrackColor: AppTheme.lightGray,
        thumbColor: AppTheme.primaryPurple,
        overlayColor: AppTheme.primaryPurple.withValues(alpha: 0.2),
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.r),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 20.r),
        trackShape: const RoundedRectSliderTrackShape(),
      ),
      child: Slider(
        value: weight,
        min: 30.0,
        max: 200.0,
        onChanged: (value) {
          setState(() {
            weight = value;
          });
        },
      ),
    );
  }
}
