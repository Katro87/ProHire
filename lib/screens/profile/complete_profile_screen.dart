import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/services/user_profile_service.dart';
import '../../core/theme/app_colors_v2.dart';
import '../../core/theme/pro_theme_v2.dart';
import '../../core/utils/screen_utils.dart';
import '../../data/models/user_profile.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _profileService = UserProfileService();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _companyController = TextEditingController();
  final _profileImageController = TextEditingController();
  final _dobController = TextEditingController();

  final _titleController = TextEditingController();
  final _skillController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _prevCompanyController = TextEditingController();
  final _prevRoleController = TextEditingController();
  final _prevDurationController = TextEditingController();

  final _lookingForController = TextEditingController();
  final _industryController = TextEditingController();

  DateTime? _dob;
  String _role = 'client';
  String _currency = 'USD';
  String _experienceLevel = 'Beginner';
  String _professionalType = 'freelancer';
  bool _displayPublic = true;
  bool _isSaving = false;

  final List<String> _skills = [];

  @override
  void initState() {
    super.initState();
    _loadPrefill();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _companyController.dispose();
    _profileImageController.dispose();
    _dobController.dispose();
    _titleController.dispose();
    _skillController.dispose();
    _hourlyRateController.dispose();
    _prevCompanyController.dispose();
    _prevRoleController.dispose();
    _prevDurationController.dispose();
    _lookingForController.dispose();
    _industryController.dispose();
    super.dispose();
  }

  Future<void> _loadPrefill() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _nameController.text = user.displayName ?? '';

    final existing = await _profileService.fetchProfile(user.uid);
    if (!mounted || existing == null) return;

    _nameController.text = existing.name;
    _bioController.text = existing.bio;
    _companyController.text = existing.companyName ?? '';
    _profileImageController.text = existing.profileImageUrl ?? '';
    _currency = existing.currency;
    _role = existing.role;
    _dob = existing.dob;
    if (_dob != null) {
      _dobController.text = _formatDate(_dob!);
    }

    final professionalData = existing.professionalData ?? {};
    if (_role == 'professional') {
      _titleController.text = professionalData['title'] as String? ?? '';
      _experienceLevel = professionalData['experienceLevel'] as String? ?? 'Beginner';
      _professionalType = professionalData['type'] as String? ?? 'freelancer';
      _hourlyRateController.text =
          (professionalData['hourlyRate'] as num?)?.toString() ?? '';
      _displayPublic = professionalData['displayPublic'] as bool? ?? true;
      _skills
        ..clear()
        ..addAll((professionalData['skills'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            []);
      final previous = professionalData['previousExperience'] as Map<String, dynamic>?;
      _prevCompanyController.text = previous?['company'] as String? ?? '';
      _prevRoleController.text = previous?['role'] as String? ?? '';
      _prevDurationController.text = previous?['duration'] as String? ?? '';
    }

    final clientData = existing.clientData ?? {};
    if (_role == 'client') {
      _lookingForController.text = clientData['lookingFor'] as String? ?? '';
      _industryController.text = clientData['industry'] as String? ?? '';
    }

    if (mounted) {
      setState(() {});
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

  @override
  Widget build(BuildContext context) {
    final screen = _screenInfo(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            screen.horizontalPadding,
            16,
            screen.horizontalPadding,
            screen.safeBottom + 24,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete Your Profile',
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
                  'Tell us more so we can personalize your experience.',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAvatarSection(isDark),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Full name is required.';
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bioController,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Bio is required.';
                    return null;
                  },
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDateOfBirthField(context),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                _buildCurrencyDropdown(),
                const SizedBox(height: 20),
                _buildRoleSelection(isDark),
                const SizedBox(height: 20),
                if (_role == 'professional') ...[
                  _buildProfessionalSection(isDark),
                ] else ...[
                  _buildClientSection(),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _profileImageController,
          decoration: const InputDecoration(
            labelText: 'Profile Image URL',
            prefixIcon: Icon(Icons.image_outlined),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Photo rules: no hats, no sunglasses, no AI-generated images.',
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildDateOfBirthField(BuildContext context) {
    return TextFormField(
      controller: _dobController,
      readOnly: true,
      validator: (_) => _dob == null ? 'Date of birth is required.' : null,
      decoration: const InputDecoration(
        labelText: 'Date of Birth',
        prefixIcon: Icon(Icons.cake_outlined),
      ),
      onTap: () async {
        final now = DateTime.now();
        final selected = await showDatePicker(
          context: context,
          initialDate: _dob ?? DateTime(now.year - 20),
          firstDate: DateTime(1900),
          lastDate: DateTime(now.year - 16),
        );
        if (selected != null) {
          setState(() {
            _dob = selected;
            _dobController.text = _formatDate(selected);
          });
        }
      },
    );
  }

  Widget _buildCurrencyDropdown() {
    return DropdownButtonFormField<String>(
      value: _currency,
      decoration: const InputDecoration(
        labelText: 'Currency',
        prefixIcon: Icon(Icons.payments_outlined),
      ),
      items: const [
        DropdownMenuItem(value: 'USD', child: Text('USD - United States Dollar')),
        DropdownMenuItem(value: 'EUR', child: Text('EUR - Euro')),
        DropdownMenuItem(value: 'GBP', child: Text('GBP - British Pound')),
        DropdownMenuItem(value: 'NGN', child: Text('NGN - Nigerian Naira')),
        DropdownMenuItem(value: 'KES', child: Text('KES - Kenyan Shilling')),
        DropdownMenuItem(value: 'ZAR', child: Text('ZAR - South African Rand')),
        DropdownMenuItem(value: 'INR', child: Text('INR - Indian Rupee')),
        DropdownMenuItem(value: 'JPY', child: Text('JPY - Japanese Yen')),
      ],
      onChanged: (value) => setState(() => _currency = value ?? 'USD'),
    );
  }

  Widget _buildRoleSelection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I am joining as',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _roleButton(
                label: 'Client',
                selected: _role == 'client',
                onTap: () => setState(() => _role = 'client'),
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _roleButton(
                label: 'Professional',
                selected: _role == 'professional',
                onTap: () => setState(() => _role = 'professional'),
                isDark: isDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _roleButton({
    required String label,
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
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected
                  ? AppColors.primary
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _titleController,
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) return 'Title is required.';
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Title',
            hintText: 'Web Developer, Sales Agent, etc',
            prefixIcon: Icon(Icons.work_outline_rounded),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _professionalType,
          decoration: const InputDecoration(
            labelText: 'Professional Type',
            prefixIcon: Icon(Icons.badge_outlined),
          ),
          items: const [
            DropdownMenuItem(value: 'trade', child: Text('Trade')),
            DropdownMenuItem(value: 'freelancer', child: Text('Freelancer')),
          ],
          onChanged: (value) => setState(() => _professionalType = value ?? 'freelancer'),
        ),
        const SizedBox(height: 12),
        _buildSkillInput(isDark),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _experienceLevel,
          decoration: const InputDecoration(
            labelText: 'Experience Level',
            prefixIcon: Icon(Icons.timeline_rounded),
          ),
          items: const [
            DropdownMenuItem(value: 'Beginner', child: Text('Beginner')),
            DropdownMenuItem(value: 'Intermediate', child: Text('Intermediate')),
            DropdownMenuItem(value: 'Expert', child: Text('Expert')),
          ],
          onChanged: (value) => setState(() => _experienceLevel = value ?? 'Beginner'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _hourlyRateController,
          keyboardType: TextInputType.number,
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) return 'Hourly rate is required.';
            if (double.tryParse(text) == null) return 'Enter a valid number.';
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Hourly Rate',
            prefixIcon: Icon(Icons.payments_outlined),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Previous Experience',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _prevCompanyController,
          decoration: const InputDecoration(
            labelText: 'Company Name',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _prevRoleController,
          decoration: const InputDecoration(
            labelText: 'Role',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _prevDurationController,
          decoration: const InputDecoration(
            labelText: 'Duration',
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          value: _displayPublic,
          onChanged: (value) => setState(() => _displayPublic = value),
          title: const Text('Display profile publicly'),
        ),
      ],
    );
  }

  Widget _buildSkillInput(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _skillController,
          decoration: InputDecoration(
            labelText: 'Skills (max 5)',
            prefixIcon: const Icon(Icons.star_outline_rounded),
            suffixIcon: TextButton(
              onPressed: _skills.length >= 5
                  ? null
                  : () {
                      final text = _skillController.text.trim();
                      if (text.isEmpty) return;
                      if (_skills.length >= 5) return;
                      setState(() {
                        _skills.add(text);
                        _skillController.clear();
                      });
                    },
              child: const Text('Add Skill'),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _skills
              .map(
                (skill) => Chip(
                  label: Text(skill),
                  onDeleted: () => setState(() => _skills.remove(skill)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildClientSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _lookingForController,
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) return 'Please tell us what you are looking for.';
            return null;
          },
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'What are you looking for?',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _industryController,
          decoration: const InputDecoration(
            labelText: 'Industry (optional)',
          ),
        ),
      ],
    );
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);

    final professionalData = _role == 'professional'
        ? {
            'title': _titleController.text.trim(),
            'skills': _skills,
            'experienceLevel': _experienceLevel,
            'hourlyRate': double.tryParse(_hourlyRateController.text.trim()) ?? 0,
            'previousExperience': {
              'company': _prevCompanyController.text.trim(),
              'role': _prevRoleController.text.trim(),
              'duration': _prevDurationController.text.trim(),
            },
            'displayPublic': _displayPublic,
            'type': _professionalType,
          }
        : null;

    final clientData = _role == 'client'
        ? {
            'lookingFor': _lookingForController.text.trim(),
            'industry': _industryController.text.trim(),
          }
        : null;

    final profile = UserProfile(
      uid: user.uid,
      name: _nameController.text.trim(),
      email: user.email ?? '',
      role: _role,
      bio: _bioController.text.trim(),
      dob: _dob,
      companyName: _companyController.text.trim().isEmpty
          ? null
          : _companyController.text.trim(),
      currency: _currency,
      profileImageUrl: _profileImageController.text.trim().isEmpty
          ? null
          : _profileImageController.text.trim(),
      professionalData: professionalData,
      clientData: clientData,
      profileComplete: true,
    );

    await _profileService.saveProfile(profile);
    await user.updateDisplayName(profile.name);

    if (!mounted) return;
    setState(() => _isSaving = false);

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
