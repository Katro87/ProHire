import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors_v2.dart';
import '../../core/theme/pro_theme_v2.dart';
import '../../core/utils/screen_utils.dart';
import '../showcase/showcase_screens.dart';
import '../home/home_screen_v2.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return const HomeScreenV2();
      case 1:
        return const _ActivityScreen();
      case 2:
        return const SizedBox(); // Placeholder for FAB
      case 3:
        return const _MessagesScreen();
      case 4:
        return const _ProfileScreen();
      default:
        return const HomeScreenV2();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = mediaQuery.size.width;
    
    // Calculate screen info directly without nested LayoutBuilder
    final deviceType = width < 600 ? DeviceType.mobile : 
                       width < 900 ? DeviceType.tablet : DeviceType.desktop;
    final screen = ScreenInfo(
      width: width,
      height: mediaQuery.size.height,
      safeTop: mediaQuery.padding.top,
      safeBottom: mediaQuery.padding.bottom,
      safeLeft: mediaQuery.padding.left,
      safeRight: mediaQuery.padding.right,
      deviceType: deviceType,
      isLandscape: width > mediaQuery.size.height,
      textScale: mediaQuery.textScaler.scale(1.0),
      pixelRatio: mediaQuery.devicePixelRatio,
    );

    return Scaffold(
      body: _buildCurrentScreen(),
      floatingActionButton: _buildFAB(context, isDark),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(context, screen, isDark),
    );
  }

  Widget _buildFAB(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/create-profile'),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: AppColors.primaryGlow(0.4),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, ScreenInfo screen, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screen.horizontalPadding,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home_rounded, 'Home', isDark),
              _buildNavItem(1, Icons.history_outlined, Icons.history_rounded, 'Activity', isDark),
              const SizedBox(width: 60), // Space for FAB
              _buildNavItem(3, Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, 'Messages', isDark),
              _buildNavItem(4, Icons.person_outline_rounded, Icons.person_rounded, 'Profile', isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label, bool isDark) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: ProTheme.fastDuration,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(ProTheme.radiusMd),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to get responsive padding
double _getHorizontalPadding(double width) {
  if (width >= 1200) return 32;
  if (width >= 600) return 24;
  if (width < 360) return 12;
  return 16;
}

double _getResponsiveFontSize(double base, double width) {
  double scale = 1.0;
  if (width < 360) scale = 0.85;
  else if (width < 415) scale = 0.92;
  else if (width < 600) scale = 1.0;
  else if (width < 900) scale = 1.08;
  else scale = 1.15;
  return base * scale;
}

// Activity Screen Placeholder
class _ActivityScreen extends StatelessWidget {
  const _ActivityScreen();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final padding = _getHorizontalPadding(width);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(padding),
              child: Text(
                'Activity',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(28, width),
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.history_rounded,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No Activity Yet',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your hire requests and activity\nwill appear here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Messages Screen Placeholder
class _MessagesScreen extends StatelessWidget {
  const _MessagesScreen();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final padding = _getHorizontalPadding(width);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(padding),
              child: Text(
                'Messages',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(28, width),
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chat_bubble_rounded,
                        size: 48,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No Messages Yet',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start a conversation with\na professional',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Profile Screen with full functionality
class _ProfileScreen extends StatefulWidget {
  const _ProfileScreen();

  @override
  State<_ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<_ProfileScreen> {
  String _userName = 'User';
  String _userEmail = 'user@email.com';
  String _userBio = '';
  String _userLocation = '';
  List<String> _userSkills = [];
  bool _isProfileLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      setState(() => _isProfileLoading = false);
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (!mounted) return;

    setState(() {
      _userName = doc.data()?['displayName'] as String? ?? user.displayName ?? 'User';
      _userEmail = doc.data()?['email'] as String? ?? user.email ?? 'user@email.com';
      _userBio = doc.data()?['bio'] as String? ?? '';
      _userLocation = doc.data()?['location'] as String? ?? '';
      _userSkills = (doc.data()?['skills'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      _isProfileLoading = false;
    });
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);
    final bioController = TextEditingController(text: _userBio);
    final locationController = TextEditingController(text: _userLocation);
    final skillsController = TextEditingController(text: _userSkills.join(', '));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar edit
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                              child: Icon(
                                Icons.person_rounded,
                                size: 50,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildTextField('Name', nameController, isDark),
                    const SizedBox(height: 16),
                    _buildTextField('Email', emailController, isDark, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    _buildTextField('Bio', bioController, isDark, maxLines: 3),
                    const SizedBox(height: 16),
                    _buildTextField('Location', locationController, isDark),
                    const SizedBox(height: 16),
                    _buildTextField('Skills (comma separated)', skillsController, isDark),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // Save button
            Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _saveProfile(
                    nameController: nameController,
                    emailController: emailController,
                    bioController: bioController,
                    locationController: locationController,
                    skillsController: skillsController,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile({
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController bioController,
    required TextEditingController locationController,
    required TextEditingController skillsController,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final skills = skillsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'displayName': nameController.text.trim(),
      'email': emailController.text.trim(),
      'bio': bioController.text.trim(),
      'location': locationController.text.trim(),
      'skills': skills,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (!mounted) return;
    setState(() {
      _userName = nameController.text.trim();
      _userEmail = emailController.text.trim();
      _userBio = bioController.text.trim();
      _userLocation = locationController.text.trim();
      _userSkills = skills;
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isDark, {int maxLines = 1, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? AppColors.cardDark : AppColors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  void _showNotificationsSettings() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).padding.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 24),
                _NotificationToggle(title: 'Push Notifications', subtitle: 'Get notified about new messages', isDark: isDark),
                _NotificationToggle(title: 'Email Notifications', subtitle: 'Receive updates via email', isDark: isDark),
                _NotificationToggle(title: 'Order Updates', subtitle: 'Get notified about order status', isDark: isDark, initialValue: true),
                _NotificationToggle(title: 'New Proposals', subtitle: 'Alert when you receive proposals', isDark: isDark, initialValue: true),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPrivacySettings() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).padding.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 24),
            _PrivacyItem(icon: Icons.visibility_outlined, title: 'Profile Visibility', subtitle: 'Public', isDark: isDark),
            _PrivacyItem(icon: Icons.location_on_outlined, title: 'Show Location', subtitle: 'Enabled', isDark: isDark),
            _PrivacyItem(icon: Icons.access_time_rounded, title: 'Online Status', subtitle: 'Visible', isDark: isDark),
            _PrivacyItem(icon: Icons.block_outlined, title: 'Blocked Users', subtitle: '0 blocked', isDark: isDark),
          ],
        ),
      ),
    );
  }

  void _showHelpSupport() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).padding.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 24),
            _HelpItem(icon: Icons.question_answer_outlined, title: 'FAQ', onTap: () => Navigator.pop(context), isDark: isDark),
            _HelpItem(icon: Icons.chat_outlined, title: 'Contact Support', onTap: () => Navigator.pop(context), isDark: isDark),
            _HelpItem(icon: Icons.bug_report_outlined, title: 'Report a Bug', onTap: () => Navigator.pop(context), isDark: isDark),
            _HelpItem(icon: Icons.feedback_outlined, title: 'Send Feedback', onTap: () => Navigator.pop(context), isDark: isDark),
          ],
        ),
      ),
    );
  }

  void _showAbout() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.work_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'About',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'A marketplace connecting skilled professionals with clients. Find trusted tradespeople and freelancers for your project needs.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Log Out',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to splash/onboarding screen
              Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
            },
            child: Text(
              'Log Out',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final padding = _getHorizontalPadding(width);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = width < 600;

    if (_isProfileLoading) {
      return const Scaffold(
        body: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Avatar
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: isMobile ? 50 : 60,
                  backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  child: Icon(
                    Icons.person_rounded,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _userName,
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(24, width),
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _userEmail,
                style: TextStyle(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              if (_userBio.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  _userBio,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                  ),
                ),
              ],
              if (_userSkills.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: _userSkills.map((skill) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  )).toList(),
                ),
              ],
              const SizedBox(height: 32),
              
              // Settings Items with working handlers
              _SettingsItem(
                icon: Icons.person_outline_rounded,
                title: 'Edit Profile',
                isDark: isDark,
                onTap: _showEditProfileDialog,
              ),
              _SettingsItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                isDark: isDark,
                onTap: _showNotificationsSettings,
              ),
              _SettingsItem(
                icon: Icons.view_carousel_outlined,
                title: 'Screen Gallery',
                isDark: isDark,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ShowcaseGalleryScreen(),
                    ),
                  );
                },
              ),
              _SettingsItem(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy',
                isDark: isDark,
                onTap: _showPrivacySettings,
              ),
              _SettingsItem(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                isDark: isDark,
                onTap: _showHelpSupport,
              ),
              _SettingsItem(
                icon: Icons.info_outline_rounded,
                title: 'About',
                isDark: isDark,
                onTap: _showAbout,
              ),
              const SizedBox(height: 16),
              _SettingsItem(
                icon: Icons.logout_rounded,
                title: 'Log Out',
                isDark: isDark,
                isDestructive: true,
                onTap: _showLogoutConfirmation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Notification toggle widget
class _NotificationToggle extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isDark;
  final bool initialValue;

  const _NotificationToggle({
    required this.title,
    required this.subtitle,
    required this.isDark,
    this.initialValue = false,
  });

  @override
  State<_NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<_NotificationToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: widget.isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _value,
            onChanged: (val) => setState(() => _value = val),
            activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary;
              }
              return null;
            }),
          ),
        ],
      ),
    );
  }
}

// Privacy item widget
class _PrivacyItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;

  const _PrivacyItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
          ),
        ],
      ),
    );
  }
}

// Help item widget
class _HelpItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDark;

  const _HelpItem({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.isDark,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ProTheme.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDestructive
                      ? AppColors.error.withValues(alpha: 0.1)
                      : (isDark ? AppColors.cardDark : AppColors.surfaceLight),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isDestructive
                      ? AppColors.error
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDestructive
                        ? AppColors.error
                        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
