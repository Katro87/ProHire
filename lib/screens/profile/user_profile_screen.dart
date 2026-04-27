import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/services/user_profile_service.dart';
import '../../core/theme/app_colors_v2.dart';
import '../../data/models/user_profile.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _service = UserProfileService();
  bool _isEnsuringProfile = true;

  @override
  void initState() {
    super.initState();
    _ensureProfile();
  }

  Future<void> _ensureProfile() async {
    if (!mounted) return;
    setState(() => _isEnsuringProfile = true);

    final user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        await _service.ensureProfile(
          user.uid,
          email: user.email,
          name: user.displayName,
        );
      }
    } catch (e) {
      debugPrint('PROFILE: ensureProfile failed: $e');
    } finally {
      if (!mounted) return;
      setState(() => _isEnsuringProfile = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view your profile.')),
      );
    }

    if (_isEnsuringProfile) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<UserProfile?>(
      stream: _service.watchProfile(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Unable to load profile right now.'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _ensureProfile,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final profile = snapshot.data;
        if (profile == null) {
          _ensureProfile();
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Profile is not ready yet.'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _ensureProfile,
                      child: const Text('Create Profile'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final skills = _extractSkills(profile);

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Profile'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => _showImageDialog(profile),
                icon: const Icon(Icons.image_outlined),
                tooltip: 'Upload profile image',
              ),
              IconButton(
                onPressed: () => _showEditDialog(profile),
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit profile',
              ),
              IconButton(
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded),
                tooltip: 'Logout',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundImage: profile.profileImageUrl?.isNotEmpty == true
                                ? NetworkImage(profile.profileImageUrl!)
                                : null,
                            child: profile.profileImageUrl?.isNotEmpty == true
                                ? null
                                : const Icon(Icons.person_outline_rounded, size: 30),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                profile.profileComplete ? Icons.verified_rounded : Icons.info_outline_rounded,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _statusChip(
                                  label: profile.profileComplete ? 'Verified' : 'Unverified',
                                  icon: profile.profileComplete ? Icons.verified_rounded : Icons.shield_outlined,
                                  color: profile.profileComplete ? AppColors.success : AppColors.warning,
                                  isDark: isDark,
                                ),
                                _statusChip(
                                  label: user.phoneNumber?.isNotEmpty == true ? 'Phone verified' : 'Phone unverified',
                                  icon: user.phoneNumber?.isNotEmpty == true ? Icons.call_rounded : Icons.call_outlined,
                                  color: user.phoneNumber?.isNotEmpty == true ? AppColors.success : AppColors.error,
                                  isDark: isDark,
                                ),
                                _statusChip(
                                  label: 'Balance: ${profile.balance.toStringAsFixed(0)}',
                                  icon: Icons.account_balance_wallet_outlined,
                                  color: AppColors.primary,
                                  isDark: isDark,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _sectionTitle('Bio'),
                Text(profile.bio.isEmpty ? 'No bio yet.' : profile.bio),
                const SizedBox(height: 16),
                _sectionTitle('Skills'),
                if (skills.isEmpty)
                  const Text('No skills yet.')
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: skills.map((skill) => Chip(label: Text(skill))).toList(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statusChip({
    required String label,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.16 : 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  List<String> _extractSkills(UserProfile profile) {
    final topLevel = (profile.clientData?['skills'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];
    final professional = (profile.professionalData?['skills'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];
    final all = [...topLevel, ...professional]
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    return all;
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  Future<void> _showEditDialog(UserProfile profile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final nameController = TextEditingController(text: profile.name);
    final emailController = TextEditingController(text: profile.email);
    final imageController = TextEditingController(text: profile.profileImageUrl ?? '');
    final bioController = TextEditingController(text: profile.bio);
    final currentSkills = _extractSkills(profile);
    final skillsController = TextEditingController(text: currentSkills.join(', '));
    String? selectedRole = profile.role.isEmpty ? null : profile.role;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              title: const Text('Edit Profile'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: imageController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(labelText: 'Profile Image URL'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedRole,
                      items: const [
                        DropdownMenuItem(value: 'client', child: Text('Client')),
                        DropdownMenuItem(value: 'professional', child: Text('Professional')),
                      ],
                      onChanged: (value) => setLocalState(() => selectedRole = value),
                      decoration: const InputDecoration(labelText: 'Role'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: bioController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Bio'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: skillsController,
                      decoration: const InputDecoration(
                        labelText: 'Skills',
                        hintText: 'Comma separated',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final navigator = Navigator.of(dialogContext);
                    final role = selectedRole;
                    final name = nameController.text.trim();
                    final email = emailController.text.trim();
                    final bio = bioController.text.trim();
                    final skills = skillsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();

                    try {
                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser == null) {
                        throw StateError('User session not available');
                      }

                      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
                        'uid': currentUser.uid,
                        'name': name.isEmpty ? 'User' : name,
                        'email': email.isEmpty ? (currentUser.email ?? profile.email) : email,
                        'profileImageUrl': imageController.text.trim().isEmpty ? null : imageController.text.trim(),
                        'role': role,
                        'bio': bio,
                        'skills': skills,
                        'professionalData': {
                          ...(profile.professionalData ?? {}),
                          'skills': skills,
                        },
                        'profileComplete':
                            (role ?? '').isNotEmpty && bio.isNotEmpty && skills.isNotEmpty,
                        'updatedAt': FieldValue.serverTimestamp(),
                      }, SetOptions(merge: true));

                      if (!mounted) return;
                      navigator.pop();
                      _showSnackBar('Profile updated successfully', isSuccess: true);
                    } catch (e, stack) {
                      debugPrint('PROFILE: update failed: $e');
                      debugPrintStack(stackTrace: stack);
                      if (!mounted) return;
                      _showSnackBar('Unable to update profile', isSuccess: false);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    emailController.dispose();
    imageController.dispose();
    bioController.dispose();
    skillsController.dispose();
  }

  Future<void> _showImageDialog(UserProfile profile) async {
    await _showEditDialog(profile);
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
  }

  void _showSnackBar(String message, {required bool isSuccess}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isSuccess ? AppColors.success : AppColors.error,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      );
  }
}
