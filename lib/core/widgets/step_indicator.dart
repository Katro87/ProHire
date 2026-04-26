import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        final isCurrent = index == currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isCurrent ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryPurple : AppTheme.backgroundLight,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class CircularStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CircularStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              value: (currentStep + 1) / totalSteps,
              strokeWidth: 4,
              backgroundColor: AppTheme.backgroundLight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.primaryPurple,
              ),
            ),
          ),
          Text(
            '${currentStep + 1}/$totalSteps',
            style: AppTheme.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
