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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _service.ensureProfile(
        user.uid,
        email: user.email,
        name: user.displayName,
      );
    }

    if (!mounted) return;
    setState(() => _isEnsuringProfile = false);
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

        final profile = snapshot.data;
        if (profile == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final skills = _extractSkills(profile);

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Profile'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => _showEditDialog(profile),
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Profile',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: profile.profileImageUrl?.isNotEmpty == true
                          ? NetworkImage(profile.profileImageUrl!)
                          : null,
                      child: profile.profileImageUrl?.isNotEmpty == true
                          ? null
                          : const Icon(Icons.person_outline_rounded, size: 28),
                    ),
                    const SizedBox(width: 12),
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
                          const SizedBox(height: 4),
                          Text(
                            'Role: ${profile.role.isEmpty ? 'Not set' : profile.role}',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                    final bio = bioController.text.trim();
                    final skills = skillsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();

                    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                      'uid': user.uid,
                      'name': name.isEmpty ? 'User' : name,
                      'email': user.email ?? profile.email,
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
    bioController.dispose();
    skillsController.dispose();
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
