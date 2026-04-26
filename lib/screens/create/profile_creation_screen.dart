import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive_utils.dart';
import '../../widgets/common_widgets.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  // Controllers
  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _experienceController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _skillController = TextEditingController();
  
  // State
  String? _selectedProfession;
  final List<String> _selectedSkills = [];
  bool _isLoading = false;

  final List<String> _professions = [
    'Software Developer',
    'UI/UX Designer',
    'Graphic Designer',
    'Mobile Developer',
    'Web Developer',
    'Electrician',
    'Plumber',
    'Tutor',
    'Photographer',
    'Content Writer',
    'Digital Marketer',
    'Business Consultant',
    'Fitness Trainer',
    'Other',
  ];

  final List<String> _suggestedSkills = [
    'JavaScript', 'Python', 'Flutter', 'React', 'Node.js',
    'Figma', 'Adobe Photoshop', 'UI Design', 'UX Research',
    'SEO', 'Content Writing', 'Marketing', 'Teaching',
    'Communication', 'Problem Solving', 'Leadership',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _aboutController.dispose();
    _experienceController.dispose();
    _hourlyRateController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.all(Responsive.getHorizontalPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo Section
              Center(
                child: _buildProfilePhoto(isDark),
              ),
              const SizedBox(height: 32),

              // Full Name
              _buildSectionTitle('Full Name', context),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Profession Dropdown
              _buildSectionTitle('Profession', context),
              const SizedBox(height: 12),
              _buildProfessionDropdown(isDark),
              const SizedBox(height: 24),

              // Experience Years
              _buildSectionTitle('Years of Experience', context),
              const SizedBox(height: 12),
              TextFormField(
                controller: _experienceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'e.g., 5',
                  prefixIcon: Icon(Icons.work_history_outlined),
                  suffixText: 'years',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your experience';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Hourly Rate
              _buildSectionTitle('Hourly Rate (\$)', context),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hourlyRateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'e.g., 50',
                  prefixIcon: Icon(Icons.attach_money_rounded),
                  suffixText: 'per hour',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your hourly rate';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Skills Section
              _buildSectionTitle('Skills', context),
              const SizedBox(height: 8),
              Text(
                'Add skills that best represent your expertise',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 12),
              _buildSkillsInput(isDark),
              const SizedBox(height: 12),
              _buildSelectedSkills(),
              const SizedBox(height: 12),
              _buildSuggestedSkills(isDark),
              const SizedBox(height: 24),

              // About Section
              _buildSectionTitle('About You', context),
              const SizedBox(height: 12),
              TextFormField(
                controller: _aboutController,
                maxLines: 5,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: 'Tell clients about yourself, your experience, and what makes you stand out...',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write something about yourself';
                  }
                  if (value.length < 50) {
                    return 'Please write at least 50 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Portfolio Section
              _buildSectionTitle('Portfolio', context),
              const SizedBox(height: 8),
              Text(
                'Showcase your best work (optional)',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 12),
              _buildPortfolioGrid(isDark),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: 'Create Profile',
                  icon: Icons.check_circle_rounded,
                  isLoading: _isLoading,
                  onPressed: _submitForm,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }

  Widget _buildProfilePhoto(bool isDark) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? AppColors.surfaceDark
                : AppColors.surfaceLight,
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.person_rounded,
            size: 56,
            color: isDark
                ? AppColors.textTertiaryDark
                : AppColors.textTertiaryLight,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () => _showPhotoOptions(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionDropdown(bool isDark) {
    return DropdownButtonFormField<String>(
      value: _selectedProfession,
      decoration: const InputDecoration(
        hintText: 'Select your profession',
        prefixIcon: Icon(Icons.work_outline_rounded),
      ),
      items: _professions.map((profession) {
        return DropdownMenuItem<String>(
          value: profession,
          child: Text(profession),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => _selectedProfession = value);
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a profession';
        }
        return null;
      },
    );
  }

  Widget _buildSkillsInput(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _skillController,
            decoration: const InputDecoration(
              hintText: 'Add a skill',
              prefixIcon: Icon(Icons.add_rounded),
            ),
            onSubmitted: (_) => _addSkill(),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _addSkill,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildSelectedSkills() {
    if (_selectedSkills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _selectedSkills.map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                skill,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _removeSkill(skill),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSuggestedSkills(bool isDark) {
    final availableSkills = _suggestedSkills
        .where((skill) => !_selectedSkills.contains(skill))
        .take(8)
        .toList();

    if (availableSkills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggested Skills:',
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? AppColors.textTertiaryDark
                : AppColors.textTertiaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableSkills.map((skill) {
            return GestureDetector(
              onTap: () {
                setState(() => _selectedSkills.add(skill));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      skill,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPortfolioGrid(bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isTablet ? 4 : 3,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        if (index == 0) {
          return GestureDetector(
            onTap: () => _addPortfolioItem(),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDark
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                border: Border.all(
                  color: AppColors.primary,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_rounded,
                    size: 32,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDark
                : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            border: Border.all(
              color: isDark
                  ? AppColors.borderDark
                  : AppColors.borderLight,
            ),
          ),
          child: Icon(
            Icons.image_outlined,
            size: 32,
            color: isDark
                ? AppColors.textTertiaryDark
                : AppColors.textTertiaryLight,
          ),
        );
      },
    );
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_selectedSkills.contains(skill)) {
      setState(() {
        _selectedSkills.add(skill);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() => _selectedSkills.remove(skill));
  }

  void _showPhotoOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.borderDark
                    : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Choose Photo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: AppColors.primary,
                ),
              ),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                // Camera functionality would go here
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.photo_library_rounded,
                  color: AppColors.secondary,
                ),
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                // Gallery functionality would go here
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _addPortfolioItem() {
    // Portfolio image picker would go here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Portfolio upload feature coming soon!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add at least one skill'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.cardDark
                : AppColors.cardLight,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.secondaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Profile Created!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your professional profile has been created successfully.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: 'Continue',
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
