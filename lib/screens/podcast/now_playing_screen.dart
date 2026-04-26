import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> 
    with TickerProviderStateMixin {
  bool isPlaying = true;
  bool isFavorite = false;
  double currentPosition = 0.35;
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.playerGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 16.h),
              
              // Header
              _buildHeader(),
              
              SizedBox(height: 32.h),
              
              // Album Art
              Expanded(
                child: Center(
                  child: _buildAlbumArt(),
                ),
              ),
              
              SizedBox(height: 32.h),
              
              // Track Info
              _buildTrackInfo(),
              
              SizedBox(height: 24.h),
              
              // Progress Bar
              _buildProgressBar(),
              
              SizedBox(height: 32.h),
              
              // Controls
              _buildControls(),
              
              SizedBox(height: 24.h),
              
              // Additional Controls
              _buildAdditionalControls(),
              
              SizedBox(height: Responsive.safeBottom + 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: AppTheme.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppTheme.white,
                size: 28.sp,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                'NOW PLAYING',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: AppTheme.white.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Daily Wellness Journey',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.white,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: AppTheme.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.more_vert_rounded,
                color: AppTheme.white,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArt() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: isPlaying ? _rotationController.value * 2 * math.pi : 0,
          child: child,
        );
      },
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final scale = 1.0 + (_pulseController.value * 0.02);
          return Transform.scale(
            scale: isPlaying ? scale : 1.0,
            child: child,
          );
        },
        child: Container(
          width: 280.w,
          height: 280.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.white.withValues(alpha: 0.15),
            boxShadow: AppTheme.albumArtShadow,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              Container(
                width: 260.w,
                height: 260.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.white.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
              ),
              // Inner circle with image
              Container(
                width: 200.w,
                height: 200.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.lightPurple.withValues(alpha: 0.8),
                      AppTheme.primaryPurple,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    '🧘‍♂️',
                    style: TextStyle(fontSize: 80.sp),
                  ),
                ),
              ),
              // Center hole (vinyl effect)
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryPurple.withValues(alpha: 0.8),
                  border: Border.all(
                    color: AppTheme.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Morning Breathing',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Sarah Johnson',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppTheme.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: isFavorite 
                    ? AppTheme.coralPink.withValues(alpha: 0.2) 
                    : AppTheme.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_outline,
                color: isFavorite ? AppTheme.coralPink : AppTheme.white,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4.h,
              activeTrackColor: AppTheme.white,
              inactiveTrackColor: AppTheme.white.withValues(alpha: 0.2),
              thumbColor: AppTheme.white,
              overlayColor: AppTheme.white.withValues(alpha: 0.1),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
            ),
            child: Slider(
              value: currentPosition,
              onChanged: (value) {
                setState(() {
                  currentPosition = value;
                });
              },
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '4:28',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppTheme.white.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  '12:45',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppTheme.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Shuffle
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shuffle_rounded,
              color: AppTheme.white.withValues(alpha: 0.7),
              size: 24.sp,
            ),
          ),
          
          // Previous
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: AppTheme.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.skip_previous_rounded,
                color: AppTheme.white,
                size: 28.sp,
              ),
            ),
          ),
          
          // Play/Pause
          GestureDetector(
            onTap: () {
              setState(() {
                isPlaying = !isPlaying;
                if (isPlaying) {
                  _rotationController.repeat();
                } else {
                  _rotationController.stop();
                }
              });
            },
            child: Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    offset: const Offset(0, 8),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: AppTheme.primaryPurple,
                size: 36.sp,
              ),
            ),
          ),
          
          // Next
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: AppTheme.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.skip_next_rounded,
                color: AppTheme.white,
                size: 28.sp,
              ),
            ),
          ),
          
          // Repeat
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.repeat_rounded,
              color: AppTheme.white.withValues(alpha: 0.7),
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalControls() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Playback speed
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppTheme.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '1.0x',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.white,
                ),
              ),
            ),
          ),
          
          // Sleep timer
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  Icons.bedtime_outlined,
                  color: AppTheme.white.withValues(alpha: 0.7),
                  size: 20.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Sleep Timer',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppTheme.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          
          // Queue
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.queue_music_rounded,
              color: AppTheme.white.withValues(alpha: 0.7),
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }
}
