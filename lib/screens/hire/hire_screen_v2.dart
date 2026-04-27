import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_colors_v2.dart';
import '../../core/theme/pro_theme_v2.dart';
import '../../core/utils/screen_utils.dart';
import '../../core/services/request_service.dart';
import '../../data/models/models.dart';
import '../../widgets/premium_widgets.dart';

class HireScreenV2 extends StatefulWidget {
  final Professional? professional;

  const HireScreenV2({super.key, this.professional});

  @override
  State<HireScreenV2> createState() => _HireScreenV2State();
}

class _HireScreenV2State extends State<HireScreenV2> {
  DateTime? _selectedDate;
  String? _selectedTime;
  final _messageController = TextEditingController();
  final _addressController = TextEditingController();
  final _requestService = RequestService();
  bool _isLoading = false;

  final List<String> _timeSlots = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  ScreenInfo _getScreenInfo(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    
    DeviceType deviceType;
    if (width < 360) {
      deviceType = DeviceType.mobileSmall;
    } else if (width < 415) {
      deviceType = DeviceType.mobile;
    } else if (width < 600) {
      deviceType = DeviceType.mobileLarge;
    } else if (width < 900) {
      deviceType = DeviceType.tablet;
    } else if (width < 1200) {
      deviceType = DeviceType.tabletLarge;
    } else {
      deviceType = DeviceType.desktop;
    }
    
    return ScreenInfo(
      width: width,
      height: height,
      safeTop: mediaQuery.padding.top,
      safeBottom: mediaQuery.padding.bottom,
      safeLeft: mediaQuery.padding.left,
      safeRight: mediaQuery.padding.right,
      deviceType: deviceType,
      isLandscape: width > height,
      textScale: mediaQuery.textScaler.scale(1.0),
      pixelRatio: mediaQuery.devicePixelRatio,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pro = widget.professional;
    if (pro == null) {
      return const Scaffold(
        body: Center(child: Text('Professional not found')),
      );
    }

    final screen = _getScreenInfo(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = pro.isTrade ? AppColors.trade : AppColors.freelance;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, screen, isDark, pro, accentColor),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(screen.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Selection
                    if (pro.isTrade) ...[
                      Text(
                        'Select Date',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 12),
                      _buildDateSelector(context, screen, isDark, accentColor),
                      const SizedBox(height: 24),

                      // Time Selection
                      Text(
                        'Select Time',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 12),
                      _buildTimeSelector(context, screen, isDark, accentColor),
                      const SizedBox(height: 24),

                      // Address
                      Text(
                        'Service Address',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your address',
                              prefixIcon: Icon(Icons.location_on_outlined),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Message
                        Text(
                          pro.isTrade ? 'Describe the Job' : 'Project Details',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _messageController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: pro.isTrade
                                ? 'Describe what you need help with...'
                                : 'Describe your project requirements...',
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Pricing Info
                        _buildPricingCard(context, screen, isDark, pro, accentColor),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomBar(context, screen, pro, accentColor),
        );
  }

  Widget _buildHeader(
    BuildContext context,
    ScreenInfo screen,
    bool isDark,
    Professional pro,
    Color accentColor,
  ) {
    return Container(
      padding: EdgeInsets.all(screen.horizontalPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(pro.avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pro.isTrade ? 'Book ${pro.name}' : 'Hire ${pro.name}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  pro.profession,
                  style: TextStyle(
                    fontSize: 13,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    ScreenInfo screen,
    bool isDark,
    Color accentColor,
  ) {
    final now = DateTime.now();
    final dates = List.generate(7, (i) => now.add(Duration(days: i)));

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _selectedDate != null &&
              _selectedDate!.day == date.day &&
              _selectedDate!.month == date.month;
          final isToday = index == 0;

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: AnimatedContainer(
              duration: ProTheme.fastDuration,
              width: 64,
              margin: EdgeInsets.only(right: index < dates.length - 1 ? 10 : 0),
              decoration: BoxDecoration(
                color: isSelected
                    ? accentColor
                    : (isDark ? AppColors.cardDark : AppColors.surfaceLight),
                borderRadius: BorderRadius.circular(ProTheme.radiusMd),
                border: isSelected
                    ? null
                    : Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getDayName(date),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.8)
                          : (isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight),
                    ),
                  ),
                  if (isToday)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  Widget _buildTimeSelector(
    BuildContext context,
    ScreenInfo screen,
    bool isDark,
    Color accentColor,
  ) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _timeSlots.map((time) {
        final isSelected = _selectedTime == time;
        return GestureDetector(
          onTap: () => setState(() => _selectedTime = time),
          child: AnimatedContainer(
            duration: ProTheme.fastDuration,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? accentColor
                  : (isDark ? AppColors.cardDark : AppColors.surfaceLight),
              borderRadius: BorderRadius.circular(ProTheme.radiusSm),
              border: isSelected
                  ? null
                  : Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPricingCard(
    BuildContext context,
    ScreenInfo screen,
    bool isDark,
    Professional pro,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(ProTheme.radiusLg),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: accentColor, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Pricing Information',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPriceRow(
            'Hourly Rate',
            '\$${pro.hourlyRate.toStringAsFixed(0)}/hr',
            isDark,
          ),
          if (pro.isFreelancer && pro.projectRate != null) ...[
            const SizedBox(height: 8),
            _buildPriceRow(
              'Min. Project',
              '\$${pro.projectRate!.toStringAsFixed(0)}',
              isDark,
            ),
          ],
          const SizedBox(height: 8),
          _buildPriceRow(
            'Service Fee',
            '\$5.00',
            isDark,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          Text(
            'Final price will be confirmed after job details are reviewed',
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textTertiaryDark
                  : AppColors.textTertiaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    ScreenInfo screen,
    Professional pro,
    Color accentColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(
        screen.horizontalPadding,
        16,
        screen.horizontalPadding,
        screen.safeBottom + 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        ),
      ),
      child: PremiumButton(
        text: pro.isTrade ? 'Confirm Booking' : 'Send Request',
        onPressed: _submitRequest,
        isLoading: _isLoading,
        gradient: pro.isTrade ? AppColors.tradeGradient : AppColors.freelanceGradient,
        height: 56,
        width: double.infinity,
      ),
    );
  }

  void _submitRequest() async {
    final pro = widget.professional!;
    
    // Validate for trade professionals
    if (pro.isTrade) {
      if (_selectedDate == null) {
        _showError('Please select a date');
        return;
      }
      if (_selectedTime == null) {
        _showError('Please select a time');
        return;
      }
      if (_addressController.text.isEmpty) {
        _showError('Please enter your address');
        return;
      }
    }

    if (_messageController.text.isEmpty) {
      _showError(pro.isTrade
          ? 'Please describe the job'
          : 'Please describe your project');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _showError('Please log in to send requests');
        setState(() => _isLoading = false);
        return;
      }

      // Create request data
      final scheduledDate = _selectedDate ?? DateTime.now();
      final address = _addressController.text.trim();
      final message = _messageController.text.trim();
      final hourlyRate = pro.hourlyRate;

      // Save request to Firestore
      await _requestService.createRequest(
        senderId: currentUser.uid,
        receiverId: pro.id,
        description: message,
        requirements: pro.isTrade ? 'On-site service required' : 'Remote project',
        duration: _selectedTime ?? 'Flexible',
        hourlyPay: hourlyRate,
        senderSnapshot: {
          'name': currentUser.displayName ?? 'User',
          'email': currentUser.email ?? '',
        },
        receiverSnapshot: {
          'name': pro.name,
          'profession': pro.profession,
        },
      );

      setState(() => _isLoading = false);

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to send request: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    final pro = widget.professional!;
    final accentColor = pro.isTrade ? AppColors.trade : AppColors.freelance;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ProTheme.radiusLg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: pro.isTrade
                      ? AppColors.tradeGradient
                      : AppColors.freelanceGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                pro.isTrade ? 'Booking Confirmed!' : 'Request Sent!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                pro.isTrade
                    ? '${pro.name} will arrive at your location on the scheduled date.'
                    : '${pro.name} will review your project and respond soon.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              PremiumButton(
                text: 'Back to Home',
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home',
                    (route) => false,
                  );
                },
                gradient: pro.isTrade
                    ? AppColors.tradeGradient
                    : AppColors.freelanceGradient,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
