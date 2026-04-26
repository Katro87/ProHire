import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/auth/firebase_auth_backend.dart';
import '../../core/theme/app_colors_v2.dart';
import '../../core/theme/pro_theme_v2.dart';
import '../../core/utils/screen_utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

enum _LoginMode { email, phone }

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final _backend = FirebaseAuthBackend();

  late final TabController _tabController;

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  final _signupEmailController = TextEditingController();
  final _signupNameController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupConfirmPasswordController = TextEditingController();

  bool _isLoginLoading = false;
  bool _isSignUpLoading = false;
  bool _isGoogleLoading = false;
  bool _isPhoneLoading = false;

  bool _loginPasswordObscured = true;
  bool _signupPasswordObscured = true;
  bool _signupConfirmPasswordObscured = true;

  bool _isOtpSent = false;
  String? _verificationId;
  int _cooldownSeconds = 0;
  Timer? _cooldownTimer;

  String _selectedRole = 'client';
  _LoginMode _loginMode = _LoginMode.email;

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
    _phoneController.dispose();
    _otpController.dispose();
    _signupEmailController.dispose();
    _signupNameController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    _cooldownTimer?.cancel();
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
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            screen.horizontalPadding,
            screen.spacing(24),
            screen.horizontalPadding,
            screen.safeBottom + screen.spacing(24),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - screen.safeBottom - screen.spacing(48),
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Container(
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
                              Tab(text: 'Sign-up'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Flexible(
                          child: AnimatedSwitcher(
                            duration: ProTheme.normalDuration,
                            switchInCurve: ProTheme.defaultCurve,
                            switchOutCurve: ProTheme.defaultCurve,
                            child: _tabController.index == 0
                                ? _buildLoginCard(context, screen, isDark)
                                : _buildSignUpCard(context, screen, isDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                onPressed: _isLoginLoading ? null : _onResetPasswordPressed,
                child: const Text('Forgot password?'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoginLoading ? null : _onLoginPressed,
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
                onPressed: _isGoogleLoading ? null : _onGooglePressed,
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
                    () => _signupConfirmPasswordObscured = !_signupConfirmPasswordObscured,
                  ),
                  icon: Icon(
                    _signupConfirmPasswordObscured
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'I am joining as',
              style: TextStyle(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _RoleButton(
                    label: 'Client',
                    icon: Icons.account_circle_outlined,
                    selected: _selectedRole == 'client',
                    onTap: () => setState(() => _selectedRole = 'client'),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _RoleButton(
                    label: 'Professional',
                    icon: Icons.work_outline_rounded,
                    selected: _selectedRole == 'professional',
                    onTap: () => setState(() => _selectedRole = 'professional'),
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isSignUpLoading ? null : _onSignUpPressed,
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

  Widget _buildPhoneSection(BuildContext context, ScreenInfo screen, bool isDark) {
    return Form(
      key: _phoneFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: _validatePhone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '+1 555 000 1234',
              prefixIcon: Icon(Icons.phone_iphone_rounded),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: (_isPhoneLoading || _cooldownSeconds > 0)
                  ? null
                  : _onSendOtpPressed,
              child: _isPhoneLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isOtpSent ? 'Resend Code' : 'Send Code'),
            ),
          ),
          if (_cooldownSeconds > 0) ...[
            const SizedBox(height: 8),
            Text(
              'Resend available in ${_cooldownSeconds}s',
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                fontSize: 13,
              ),
            ),
          ],
          if (_isOtpSent) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              validator: _validateOtp,
              decoration: const InputDecoration(
                labelText: 'Verification Code',
                hintText: 'Enter 6-digit code',
                prefixIcon: Icon(Icons.lock_open_rounded),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isPhoneLoading ? null : _onVerifyOtpPressed,
                child: _isPhoneLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Verify & Continue'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoginModeToggle(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(ProTheme.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              label: 'Email',
              icon: Icons.mail_outline_rounded,
              isSelected: _loginMode == _LoginMode.email,
              isDark: isDark,
              onTap: () => setState(() {
                _loginMode = _LoginMode.email;
              }),
            ),
          ),
          Expanded(
            child: _ModeButton(
              label: 'Phone',
              icon: Icons.phone_iphone_rounded,
              isSelected: _loginMode == _LoginMode.phone,
              isDark: isDark,
              onTap: () => setState(() {
                _loginMode = _LoginMode.phone;
              }),
            ),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email is required.';
    final regex = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (!regex.hasMatch(text)) return 'Enter a valid email address.';
    return null;
  }

  String? _validateName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Name is required.';
    if (text.length < 2) return 'Name must be at least 2 characters.';
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Password is required.';
    if (text.length < 8) return 'Password must be at least 8 characters.';
    if (!text.contains(RegExp(r'[A-Z]'))) return 'Add at least one uppercase letter.';
    if (!text.contains(RegExp(r'[0-9]'))) return 'Add at least one number.';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if ((value ?? '').isEmpty) return 'Confirm your password.';
    if (value != _signupPasswordController.text) return 'Passwords do not match.';
    return null;
  }

  String? _validatePhone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Phone number is required.';
    final regex = RegExp(r'^\+?[0-9]{8,15}$');
    if (!regex.hasMatch(text.replaceAll(' ', ''))) {
      return 'Use international format (e.g. +15550001234).';
    }
    return null;
  }

  String? _validateOtp(String? value) {
    final text = value?.trim() ?? '';
    if (text.length < 4) return 'Enter the code from SMS.';
    return null;
  }

  void _startCooldown(int seconds) {
    _cooldownTimer?.cancel();
    setState(() => _cooldownSeconds = seconds);

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_cooldownSeconds <= 1) {
        timer.cancel();
        setState(() => _cooldownSeconds = 0);
      } else {
        setState(() => _cooldownSeconds -= 1);
      }
    });
  }

  Widget _RoleButton({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ProTheme.radiusMd),
      child: AnimatedContainer(
        duration: ProTheme.fastDuration,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? AppColors.surfaceDark : AppColors.primarySurface)
              : (isDark ? AppColors.cardDark : AppColors.surfaceLight),
          borderRadius: BorderRadius.circular(ProTheme.radiusMd),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? AppColors.primary
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected
                    ? AppColors.primary
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ModeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ProTheme.radiusLg),
      child: AnimatedContainer(
        duration: ProTheme.fastDuration,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.cardDark : AppColors.primarySurface)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(ProTheme.radiusLg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onLoginPressed() async {
    if (!(_loginFormKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _isLoginLoading = true);

    final result = await _backend.login(
      email: _loginEmailController.text,
      password: _loginPasswordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoginLoading = false);

    _showNotification(result);

    if (result.isSuccess) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _onSignUpPressed() async {
    if (!(_signupFormKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _isSignUpLoading = true);

    final result = await _backend.signUp(
      displayName: _signupNameController.text.trim(),
      email: _signupEmailController.text,
      password: _signupPasswordController.text,
      confirmPassword: _signupConfirmPasswordController.text,
    );

    if (!mounted) return;
    setState(() => _isSignUpLoading = false);

    _showNotification(result);

    if (result.isSuccess) {
      await _backend.updateUserRole(_selectedRole);
      _tabController.animateTo(0);
      _signupNameController.clear();
      _loginEmailController.text = _signupEmailController.text.trim();
      _loginPasswordController.clear();
    }
  }

  Future<void> _onResetPasswordPressed() async {
    final result = await _backend.sendPasswordReset(
      email: _loginEmailController.text,
    );

    if (!mounted) return;
    _showNotification(result);
  }

  Future<void> _onSendOtpPressed() async {
    if (!(_phoneFormKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isPhoneLoading = true);

    final result = await _backend.sendPhoneOtp(
      phoneNumber: _phoneController.text.replaceAll(' ', ''),
      onCodeSent: (verificationId, resendToken) {
        if (!mounted) return;
        setState(() {
          _verificationId = verificationId;
          _isOtpSent = true;
        });
        _startCooldown(60);
      },
      onFailed: (failure) {
        if (!mounted) return;
        _showNotification(failure);
      },
      onAutoVerified: () {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      },
    );

    if (!mounted) return;
    setState(() => _isPhoneLoading = false);
    _showNotification(result);
  }

  Future<void> _onVerifyOtpPressed() async {
    if (!(_phoneFormKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isPhoneLoading = true);

    final result = await _backend.verifyPhoneOtp(
      verificationId: _verificationId ?? '',
      smsCode: _otpController.text,
    );

    if (!mounted) return;
    setState(() => _isPhoneLoading = false);
    _showNotification(result);

    if (result.isSuccess) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _onGooglePressed() async {
    setState(() => _isGoogleLoading = true);

    final result = await _backend.signInWithGoogle();

    if (!mounted) return;
    setState(() => _isGoogleLoading = false);
    _showNotification(result);

    if (result.isSuccess) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _showNotification(AuthResult result) {
    final color = result.isSuccess ? AppColors.success : _colorForError(result.errorCase);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
      ),
    );
  }

  Color _colorForError(AuthErrorCase errorCase) {
    switch (errorCase) {
      case AuthErrorCase.none:
        return AppColors.success;
      case AuthErrorCase.invalidEmail:
      case AuthErrorCase.invalidPhoneNumber:
      case AuthErrorCase.wrongPassword:
      case AuthErrorCase.passwordsDoNotMatch:
      case AuthErrorCase.weakPassword:
      case AuthErrorCase.emptyEmail:
      case AuthErrorCase.emptyPassword:
      case AuthErrorCase.emptyConfirmPassword:
      case AuthErrorCase.smsCodeInvalid:
      case AuthErrorCase.smsCodeExpired:
      case AuthErrorCase.cancelled:
        return AppColors.warning;
      case AuthErrorCase.userNotFound:
      case AuthErrorCase.emailAlreadyInUse:
      case AuthErrorCase.smsQuotaExceeded:
      case AuthErrorCase.tooManyRequests:
      case AuthErrorCase.network:
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
