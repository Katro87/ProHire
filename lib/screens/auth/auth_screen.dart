import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/auth/firebase_auth_backend.dart';
import '../../core/services/user_profile_service.dart';
import '../../core/theme/app_colors_v2.dart';
import '../../core/theme/pro_theme_v2.dart';
import '../../core/utils/screen_utils.dart';
import '../navigation/main_navigation_v2.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final _backend = FirebaseAuthBackend();
  final _profileService = UserProfileService();

  late final TabController _tabController;

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _signupNameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupConfirmPasswordController = TextEditingController();

  bool _isLoginLoading = false;
  bool _isSignUpLoading = false;
  bool _isGoogleLoading = false;

  bool _loginPasswordObscured = true;
  bool _signupPasswordObscured = true;
  bool _signupConfirmPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    setState(() {});
  }

  Widget _buildBrandPanel(BuildContext context, ScreenInfo screen, bool isDark) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        screen.horizontalPadding,
        screen.spacing(28),
        screen.horizontalPadding,
        screen.safeBottom + screen.spacing(28),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ProTheme.radiusXl),
          gradient: AppColors.primaryGradient,
          boxShadow: AppColors.strongShadow,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -40,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!kIsWeb)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(ProTheme.radiusFull),
                      ),
                      child: const Text(
                        'Welcome',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    'Hire verified professionals with confidence.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screen.fontSize(30),
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Premium talent, seamless hiring, and protected payments in one unified workspace.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: screen.fontSize(14),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildBrandStat(
                    icon: Icons.verified_outlined,
                    title: 'Trusted Pros',
                    subtitle: 'Identity and skill checks',
                  ),
                  const SizedBox(height: 16),
                  _buildBrandStat(
                    icon: Icons.shield_outlined,
                    title: 'Secure Payments',
                    subtitle: 'Milestone-based protection',
                  ),
                  const SizedBox(height: 16),
                  _buildBrandStat(
                    icon: Icons.bolt_outlined,
                    title: 'Fast Hiring',
                    subtitle: 'Book in minutes, not days',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandStat({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(ProTheme.radiusMd),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAuthPanel(
    BuildContext context,
    ScreenInfo screen,
    bool isDark,
    bool showBrandHeader,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - screen.safeBottom - screen.spacing(48),
              maxWidth: screenWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: screen.spacing(24)),
                Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: screen.fontSize(24),
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Log in or create an account to continue.',
                  style: TextStyle(
                    fontSize: screen.fontSize(14),
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(ProTheme.radiusLg),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                          boxShadow: isDark ? null : AppColors.softShadow,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(ProTheme.radiusLg),
                                border: Border.all(
                                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                ),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                tabs: const [
                                  Tab(text: 'Login'),
                                  Tab(text: 'Signup'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            AnimatedSwitcher(
                              duration: ProTheme.normalDuration,
                              switchInCurve: ProTheme.defaultCurve,
                              switchOutCurve: ProTheme.defaultCurve,
                              child: _tabController.index == 0
                                  ? _buildLoginCard(context, screen, isDark)
                                  : _buildSignUpCard(context, screen, isDark),
                            ),
                          ],
                        ),
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

  @override
  Widget build(BuildContext context) {
    final screen = _screenInfo(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          gradient: isDark ? AppColors.darkGradient : null,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: isWide
                      ? Row(
                          children: [
                            Expanded(child: _buildBrandPanel(context, screen, isDark)),
                            Expanded(child: _buildAuthPanel(context, screen, isDark, false)),
                          ],
                        )
                      : _buildAuthPanel(context, screen, isDark, true),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context, ScreenInfo screen, bool isDark) {
    final isBusy = _isLoginLoading || _isSignUpLoading || _isGoogleLoading;

    return _FormCard(
      isDark: isDark,
      child: Form(
        key: _loginFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _loginEmailController,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _loginPasswordController,
              obscureText: _loginPasswordObscured,
              validator: _validatePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () => setState(
                    () => _loginPasswordObscured = !_loginPasswordObscured,
                  ),
                  icon: Icon(
                    _loginPasswordObscured
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: isBusy ? null : _onResetPasswordPressed,
                child: const Text('Forgot Password?'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: isBusy ? null : _onLoginPressed,
                child: _isLoginLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login'),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: isBusy ? null : _onGooglePressed,
                icon: _isGoogleLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.g_mobiledata_rounded, size: 28),
                label: const Text('Continue with Google'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpCard(BuildContext context, ScreenInfo screen, bool isDark) {
    final isBusy = _isLoginLoading || _isSignUpLoading || _isGoogleLoading;

    return _FormCard(
      isDark: isDark,
      child: Form(
        key: _signupFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _signupNameController,
              validator: _validateName,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _signupEmailController,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _signupPasswordController,
              obscureText: _signupPasswordObscured,
              validator: _validatePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () => setState(
                    () => _signupPasswordObscured = !_signupPasswordObscured,
                  ),
                  icon: Icon(
                    _signupPasswordObscured
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _signupConfirmPasswordController,
              obscureText: _signupConfirmPasswordObscured,
              validator: _validateConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_reset_rounded),
                suffixIcon: IconButton(
                  onPressed: () => setState(
                    () => _signupConfirmPasswordObscured =
                        !_signupConfirmPasswordObscured,
                  ),
                  icon: Icon(
                    _signupConfirmPasswordObscured
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: isBusy ? null : _onSignUpPressed,
                child: _isSignUpLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email is required.';
    if (!text.contains('@')) return 'Invalid email format';
    return null;
  }

  String? _validateName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Full name is required.';
    if (text.length < 2) return 'Enter your full name.';
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Password is required.';
    if (text.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Confirm password is required.';
    if (text != _signupPasswordController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _onLoginPressed() async {
    if (!(_loginFormKey.currentState?.validate() ?? false)) {
      return;
    }
    debugPrint('AUTH: Login button pressed for ${_loginEmailController.text.trim()}');
    setState(() => _isLoginLoading = true);

    try {
      final result = await _backend.login(
        email: _loginEmailController.text,
        password: _loginPasswordController.text,
      );

      debugPrint('AUTH: Login API result => success=${result.isSuccess}, message=${result.message}');

      if (!mounted) return;

      if (result.isSuccess) {
        await _handlePostAuthSuccess(name: result.userName);
        return;
      }

      _showNotification(result);
    } catch (e, stack) {
      debugPrint('AUTH: Login exception: $e');
      debugPrintStack(stackTrace: stack);
      if (!mounted) return;
      _showStyledSnackBar('Unable to login right now. Please try again.', isSuccess: false);
    } finally {
      if (mounted) {
        setState(() => _isLoginLoading = false);
      }
    }
  }

  Future<void> _onSignUpPressed() async {
    if (!(_signupFormKey.currentState?.validate() ?? false)) {
      return;
    }
    debugPrint('AUTH: Signup button pressed for ${_signupEmailController.text.trim()}');
    setState(() => _isSignUpLoading = true);

    try {
      final result = await _backend.signUp(
        email: _signupEmailController.text,
        password: _signupPasswordController.text,
        confirmPassword: _signupConfirmPasswordController.text,
        displayName: _signupNameController.text.trim(),
      );

      debugPrint('AUTH: Signup API result => success=${result.isSuccess}, message=${result.message}');

      if (!mounted) return;

      if (result.isSuccess) {
        _signupNameController.clear();
        _signupPasswordController.clear();
        _signupConfirmPasswordController.clear();
        await _handlePostAuthSuccess(name: result.userName);
        return;
      }

      _showNotification(result);
    } catch (e, stack) {
      debugPrint('AUTH: Signup exception: $e');
      debugPrintStack(stackTrace: stack);
      if (!mounted) return;
      _showStyledSnackBar('Unable to create account right now. Please try again.', isSuccess: false);
    } finally {
      if (mounted) {
        setState(() => _isSignUpLoading = false);
      }
    }
  }

  Future<void> _onResetPasswordPressed() async {
    final email = await _showResetPasswordDialog();
    if (email == null) return;

    try {
      final trimmed = email.trim();
      if (trimmed.isNotEmpty) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: trimmed);
      }
    } catch (e, stack) {
      debugPrint('AUTH: Password reset request failed (generic response shown): $e');
      debugPrintStack(stackTrace: stack);
    }

    if (!mounted) return;
    _showStyledSnackBar(
      'If this email exists, a reset link has been sent',
      isSuccess: true,
    );
  }

  Future<void> _onGooglePressed() async {
    debugPrint('AUTH: Google sign-in button pressed');
    setState(() => _isGoogleLoading = true);

    try {
      final result = await _backend.signInWithGoogle();
      debugPrint('AUTH: Google API result => success=${result.isSuccess}, message=${result.message}');

      if (!mounted) return;

      if (result.isSuccess) {
        await _handlePostAuthSuccess(name: result.userName);
        return;
      }

      _showNotification(result);
    } catch (e, stack) {
      debugPrint('AUTH: Google sign-in exception: $e');
      debugPrintStack(stackTrace: stack);
      if (!mounted) return;
      _showStyledSnackBar('Unable to sign in with Google. Please try again.', isSuccess: false);
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  Future<void> _handlePostAuthSuccess({String? name}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || !mounted) {
      debugPrint('AUTH: currentUser is null after success result');
      if (mounted) {
        _showStyledSnackBar('Login succeeded but session not ready. Please try once more.', isSuccess: false);
      }
      return;
    }

    try {
      final profile = await _profileService.ensureProfile(
        currentUser.uid,
        email: currentUser.email,
        name: name ?? currentUser.displayName,
      );

      final rawDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final rawData = rawDoc.data() ?? <String, dynamic>{};

      if (!mounted) return;
      final isIncomplete = _isProfileIncomplete(profileMap: {
        'role': rawData['role'],
        'bio': rawData['bio'],
        'skills': rawData['skills'],
      });

      final safeName = (name ?? profile.name).trim().isEmpty ? 'User' : (name ?? profile.name).trim();
      _showStyledSnackBar('Welcome, $safeName!', isSuccess: true);

      if (!isIncomplete) {
        _navigateToHome();
        return;
      }

      final completeNow = await _showCompleteProfileDialog();
      if (!mounted) return;
      if (completeNow) {
        _navigateToProfile();
      } else {
        _navigateToHome();
      }
    } catch (e, stack) {
      debugPrint('AUTH: Post-login handling error: $e');
      debugPrintStack(stackTrace: stack);
      if (!mounted) return;
      _showStyledSnackBar('Signed in, but profile setup failed. Opening home.', isSuccess: false);
      _navigateToHome();
    }
  }

  bool _isProfileIncomplete({required Map<String, dynamic> profileMap}) {
    final role = (profileMap['role'] as String?)?.trim() ?? '';
    final bio = (profileMap['bio'] as String?)?.trim() ?? '';
    final skills = (profileMap['skills'] as List?)
            ?.map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList() ??
        <String>[];

    return role.isEmpty || bio.isEmpty || skills.isEmpty;
  }

  Future<bool> _showCompleteProfileDialog() async {
    final action = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Complete Your Profile'),
          content: const Text(
            'Complete your profile to attract more clients or professionals.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Complete Now'),
            ),
          ],
        );
      },
    );

    return action ?? false;
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  void _navigateToProfile() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation(initialIndex: 4)),
    );
  }

  Future<String?> _showResetPasswordDialog() async {
    final controller = TextEditingController(text: _loginEmailController.text.trim());

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.mail_outline_rounded),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text.trim());
              },
              child: const Text('Send Link'),
            ),
          ],
        );
      },
    );

    controller.dispose();
    return result;
  }

  void _showNotification(AuthResult result) {
    _showStyledSnackBar(
      result.message,
      isSuccess: result.isSuccess,
      colorOverride: result.isSuccess ? null : _colorForError(result.errorCase),
    );
  }

  void _showStyledSnackBar(
    String message, {
    required bool isSuccess,
    Color? colorOverride,
  }) {
    final color = colorOverride ?? (isSuccess ? AppColors.success : AppColors.error);

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      );
  }

  Color _colorForError(AuthErrorCase errorCase) {
    switch (errorCase) {
      case AuthErrorCase.none:
        return AppColors.success;
      case AuthErrorCase.invalidEmail:
      case AuthErrorCase.passwordsDoNotMatch:
      case AuthErrorCase.wrongPassword:
      case AuthErrorCase.weakPassword:
      case AuthErrorCase.emptyEmail:
      case AuthErrorCase.emptyPassword:
      case AuthErrorCase.emptyConfirmPassword:
      case AuthErrorCase.userNotFound:
      case AuthErrorCase.emailAlreadyInUse:
      case AuthErrorCase.tooManyRequests:
      case AuthErrorCase.network:
      case AuthErrorCase.cancelled:
      case AuthErrorCase.unknown:
        return AppColors.error;
    }
  }

}

class _FormCard extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const _FormCard({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(ProTheme.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: isDark ? null : AppColors.softShadow,
      ),
      child: child,
    );
  }
}

ScreenInfo _screenInfo(BuildContext context) {
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
