import 'package:flutter/material.dart';
import '../../core/theme/app_colors_v2.dart';
import '../../core/theme/pro_theme_v2.dart';
import '../../core/utils/screen_utils.dart';
import '../../data/models/models.dart';
import '../../widgets/premium_widgets.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  ProfessionalType? _selectedType;

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
    final screen = _getScreenInfo(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_selectedType != null) {
      return _selectedType == ProfessionalType.trade
          ? TradeProfileForm(onBack: () => setState(() => _selectedType = null))
          : FreelancerProfileForm(onBack: () => setState(() => _selectedType = null));
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screen.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Title
              Text(
                'Create Your\nProfessional Profile',
                style: TextStyle(
                  fontSize: screen.fontSize(32),
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Choose the type of professional profile you want to create',
                style: TextStyle(
                  fontSize: screen.fontSize(16),
                  color: isDark
                      ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Trade Card
                  _buildTypeCard(
                    context: context,
                    screen: screen,
                    isDark: isDark,
                    type: ProfessionalType.trade,
                    title: 'Trade Professional',
                    subtitle: 'Plumber, Electrician, Carpenter, Painter, etc.',
                    icon: Icons.build_rounded,
                    gradient: AppColors.tradeGradient,
                    color: AppColors.trade,
                    examples: ['🔧 Plumber', '⚡ Electrician', '🪚 Carpenter', '🎨 Painter'],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Freelancer Card
                  _buildTypeCard(
                    context: context,
                    screen: screen,
                    isDark: isDark,
                    type: ProfessionalType.freelancer,
                    title: 'Freelancer',
                    subtitle: 'Developer, Designer, Writer, Marketer, etc.',
                    icon: Icons.laptop_mac_rounded,
                    gradient: AppColors.freelanceGradient,
                    color: AppColors.freelance,
                    examples: ['💻 Developer', '🎨 Designer', '✍️ Writer', '📈 Marketer'],
                  ),
                  
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
  }

  Widget _buildTypeCard({
    required BuildContext context,
    required ScreenInfo screen,
    required bool isDark,
    required ProfessionalType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required Color color,
    required List<String> examples,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(ProTheme.radiusLg),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          boxShadow: isDark ? null : AppColors.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: screen.fontSize(18),
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: color,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: examples.map((e) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  e,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Trade Professional Form
class TradeProfileForm extends StatefulWidget {
  final VoidCallback onBack;
  
  const TradeProfileForm({super.key, required this.onBack});

  @override
  State<TradeProfileForm> createState() => _TradeProfileFormState();
}

class _TradeProfileFormState extends State<TradeProfileForm> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _experienceController = TextEditingController();
  final _bioController = TextEditingController();
  
  String? _selectedCategory;
  final List<String> _selectedSkills = [];
  final List<String> _certifications = [];

  final List<String> _tradeSkills = [
    'Pipe Repair', 'Water Heater', 'Drain Cleaning', 'Fixture Installation',
    'Wiring', 'Panel Upgrades', 'Lighting Installation', 'Outlet Repair',
    'Framing', 'Cabinet Making', 'Deck Building', 'Trim Work',
    'Interior Painting', 'Exterior Painting', 'Staining', 'Wallpaper',
    'AC Repair', 'Furnace Service', 'Duct Work', 'Heat Pump',
    'General Repairs', 'Assembly', 'Mounting', 'Heavy Lifting',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _hourlyRateController.dispose();
    _experienceController.dispose();
    _bioController.dispose();
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
    final screen = _getScreenInfo(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(screen.horizontalPadding),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trade Professional',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                            Text(
                              'Step ${_currentStep + 1} of 3',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.trade,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Progress Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screen.horizontalPadding),
                  child: Row(
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                          decoration: BoxDecoration(
                            gradient: index <= _currentStep ? AppColors.tradeGradient : null,
                            color: index <= _currentStep
                                ? null
                                : (isDark ? AppColors.borderDark : AppColors.borderLight),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 24),

                // Form Content
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: screen.horizontalPadding),
                      child: _buildCurrentStep(context, screen, isDark),
                    ),
                  ),
                ),

                // Bottom Buttons
                Container(
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
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: PremiumButton(
                            text: 'Back',
                            onPressed: () => setState(() => _currentStep--),
                            isOutlined: true,
                            color: AppColors.trade,
                            height: 52,
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: _currentStep > 0 ? 2 : 1,
                        child: PremiumButton(
                          text: _currentStep == 2 ? 'Create Profile' : 'Continue',
                          onPressed: _nextStep,
                          gradient: AppColors.tradeGradient,
                          height: 52,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
  }

  Widget _buildCurrentStep(BuildContext context, ScreenInfo screen, bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep(context, screen, isDark);
      case 1:
        return _buildSkillsStep(context, screen, isDark);
      case 2:
        return _buildRatesStep(context, screen, isDark);
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicInfoStep(BuildContext context, ScreenInfo screen, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: TextStyle(
            fontSize: screen.fontSize(24),
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tell us about yourself',
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 24),
        
        _buildTextField(
          controller: _nameController,
          label: 'Full Name',
          hint: 'Enter your full name',
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          hint: 'Enter your phone number',
          keyboardType: TextInputType.phone,
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        
        _buildTextField(
          controller: _addressController,
          label: 'Service Area',
          hint: 'City, State',
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        
        // Category Selection
        Text(
          'Trade Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TradeCategories.all.map((cat) {
            final isSelected = _selectedCategory == cat.id;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat.id),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.tradeGradient : null,
                  color: isSelected ? null : (isDark ? AppColors.cardDark : AppColors.surfaceLight),
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected ? null : Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(cat.icon, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSkillsStep(BuildContext context, ScreenInfo screen, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Skills',
          style: TextStyle(
            fontSize: screen.fontSize(24),
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select the skills you offer',
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 24),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _tradeSkills.map((skill) {
            final isSelected = _selectedSkills.contains(skill);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedSkills.remove(skill);
                  } else {
                    _selectedSkills.add(skill);
                  }
                });
              },
              child: AnimatedContainer(
                duration: ProTheme.fastDuration,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.trade.withValues(alpha: 0.15)
                      : (isDark ? AppColors.cardDark : AppColors.surfaceLight),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.trade
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      Icon(Icons.check, size: 16, color: AppColors.trade),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      skill,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? AppColors.trade
                            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        
        _buildTextField(
          controller: _experienceController,
          label: 'Years of Experience',
          hint: 'e.g., 5',
          keyboardType: TextInputType.number,
          isDark: isDark,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildRatesStep(BuildContext context, ScreenInfo screen, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rates & Bio',
          style: TextStyle(
            fontSize: screen.fontSize(24),
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Set your hourly rate and write a bio',
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 24),
        
        _buildTextField(
          controller: _hourlyRateController,
          label: 'Hourly Rate (\$)',
          hint: 'e.g., 75',
          keyboardType: TextInputType.number,
          isDark: isDark,
          prefix: '\$',
          suffix: '/hr',
        ),
        const SizedBox(height: 16),
        
        _buildTextField(
          controller: _bioController,
          label: 'Professional Bio',
          hint: 'Tell clients about your experience, specialties, and what sets you apart...',
          isDark: isDark,
          maxLines: 5,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? prefix,
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            suffixText: suffix,
          ),
        ),
      ],
    );
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      // Submit form
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ProTheme.radiusLg),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.tradeGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 24),
            const Text(
              'Profile Created!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your trade professional profile is now live.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 24),
            PremiumButton(
              text: 'Go to Home',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/home');
              },
              gradient: AppColors.tradeGradient,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

// Freelancer Form (simplified version - follows same pattern)
class FreelancerProfileForm extends StatefulWidget {
  final VoidCallback onBack;
  
  const FreelancerProfileForm({super.key, required this.onBack});

  @override
  State<FreelancerProfileForm> createState() => _FreelancerProfileFormState();
}

class _FreelancerProfileFormState extends State<FreelancerProfileForm> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _projectRateController = TextEditingController();
  final _bioController = TextEditingController();
  final _portfolioUrlController = TextEditingController();
  
  String? _selectedCategory;
  final List<String> _selectedSkills = [];

  final List<String> _freelanceSkills = [
    'React', 'Node.js', 'Flutter', 'Python', 'JavaScript', 'TypeScript',
    'UI Design', 'UX Research', 'Figma', 'Adobe XD', 'Prototyping',
    'Copywriting', 'SEO Content', 'Blog Posts', 'Technical Writing',
    'Video Editing', 'Motion Graphics', 'Color Grading', 'Animation',
    'Social Media', 'Google Ads', 'Facebook Ads', 'Email Marketing',
    'Photography', 'Photo Editing', 'Lightroom', 'Photoshop',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _hourlyRateController.dispose();
    _projectRateController.dispose();
    _bioController.dispose();
    _portfolioUrlController.dispose();
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
    final screen = _getScreenInfo(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(screen.horizontalPadding),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Freelancer Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          'Step ${_currentStep + 1} of 3',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.freelance,
                          ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Progress Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screen.horizontalPadding),
                  child: Row(
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                          decoration: BoxDecoration(
                            gradient: index <= _currentStep ? AppColors.freelanceGradient : null,
                            color: index <= _currentStep
                                ? null
                                : (isDark ? AppColors.borderDark : AppColors.borderLight),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 24),

                // Form Content
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: screen.horizontalPadding),
                      child: _buildCurrentStep(context, screen, isDark),
                    ),
                  ),
                ),

                // Bottom Buttons
                Container(
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
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: PremiumButton(
                            text: 'Back',
                            onPressed: () => setState(() => _currentStep--),
                            isOutlined: true,
                            color: AppColors.freelance,
                            height: 52,
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: _currentStep > 0 ? 2 : 1,
                        child: PremiumButton(
                          text: _currentStep == 2 ? 'Create Profile' : 'Continue',
                          onPressed: _nextStep,
                          gradient: AppColors.freelanceGradient,
                          height: 52,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
  }

  Widget _buildCurrentStep(BuildContext context, ScreenInfo screen, bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep(context, screen, isDark);
      case 1:
        return _buildSkillsStep(context, screen, isDark);
      case 2:
        return _buildRatesStep(context, screen, isDark);
      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicInfoStep(BuildContext context, ScreenInfo screen, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: TextStyle(
            fontSize: screen.fontSize(24),
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tell us about yourself',
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 24),
        
        _buildTextField(
          controller: _nameController,
          label: 'Full Name',
          hint: 'Enter your full name',
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'your@email.com',
          keyboardType: TextInputType.emailAddress,
          isDark: isDark,
        ),
        const SizedBox(height: 16),
        
        // Category Selection
        Text(
          'Freelance Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: FreelancerCategories.all.map((cat) {
            final isSelected = _selectedCategory == cat.id;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat.id),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.freelanceGradient : null,
                  color: isSelected ? null : (isDark ? AppColors.cardDark : AppColors.surfaceLight),
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected ? null : Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(cat.icon, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSkillsStep(BuildContext context, ScreenInfo screen, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Skills',
          style: TextStyle(
            fontSize: screen.fontSize(24),
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select your expertise areas',
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 24),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _freelanceSkills.map((skill) {
            final isSelected = _selectedSkills.contains(skill);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedSkills.remove(skill);
                  } else {
                    _selectedSkills.add(skill);
                  }
                });
              },
              child: AnimatedContainer(
                duration: ProTheme.fastDuration,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.freelance.withValues(alpha: 0.15)
                      : (isDark ? AppColors.cardDark : AppColors.surfaceLight),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.freelance
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      Icon(Icons.check, size: 16, color: AppColors.freelance),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      skill,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? AppColors.freelance
                            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        
        _buildTextField(
          controller: _portfolioUrlController,
          label: 'Portfolio URL (Optional)',
          hint: 'https://yourportfolio.com',
          keyboardType: TextInputType.url,
          isDark: isDark,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildRatesStep(BuildContext context, ScreenInfo screen, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rates & Bio',
          style: TextStyle(
            fontSize: screen.fontSize(24),
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Set your rates and write a compelling bio',
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 24),
        
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _hourlyRateController,
                label: 'Hourly Rate',
                hint: '75',
                keyboardType: TextInputType.number,
                isDark: isDark,
                prefix: '\$',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _projectRateController,
                label: 'Min. Project Rate',
                hint: '500',
                keyboardType: TextInputType.number,
                isDark: isDark,
                prefix: '\$',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        _buildTextField(
          controller: _bioController,
          label: 'Professional Bio',
          hint: 'Describe your expertise, experience, and what makes you unique...',
          isDark: isDark,
          maxLines: 5,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
          ),
        ),
      ],
    );
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ProTheme.radiusLg),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.freelanceGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 24),
            const Text(
              'Profile Created!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your freelancer profile is now live.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 24),
            PremiumButton(
              text: 'Go to Home',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/home');
              },
              gradient: AppColors.freelanceGradient,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
