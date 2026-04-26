import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/services/user_profile_service.dart';
import '../../core/theme/app_colors_v2.dart';
import '../../core/theme/pro_theme_v2.dart';
import '../../data/models/user_profile.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view your profile.')),
      );
    }

    final service = UserProfileService();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<UserProfile?>(
      stream: service.watchProfile(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = snapshot.data;
        if (profile == null) {
          return const Scaffold(
            body: Center(child: Text('Profile not found.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Profile'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: profile.profileImageUrl?.isNotEmpty == true
                          ? NetworkImage(profile.profileImageUrl!)
                          : null,
                      child: profile.profileImageUrl?.isNotEmpty == true
                          ? null
                          : const Icon(Icons.person, size: 36),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.email,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Role: ${profile.role}',
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
                _sectionHeader('Bio'),
                Text(profile.bio),
                const SizedBox(height: 16),
                _sectionHeader('Currency'),
                Text(profile.currency),
                const SizedBox(height: 16),
                if (profile.role == 'professional') ...[
                  _sectionHeader('Professional Details'),
                  _buildProfessionalSection(profile.professionalData ?? {}),
                  const SizedBox(height: 12),
                ],
                if (profile.role == 'client') ...[
                  _sectionHeader('Client Details'),
                  _buildClientSection(profile.clientData ?? {}),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProfessionalSection(Map<String, dynamic> data) {
    final skills = (data['skills'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final previous = data['previousExperience'] as Map<String, dynamic>?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Title: ${data['title'] ?? '—'}'),
        Text('Experience: ${data['experienceLevel'] ?? '—'}'),
        Text('Hourly Rate: ${data['hourlyRate'] ?? '—'}'),
        if (skills.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: skills.map((skill) => Chip(label: Text(skill))).toList(),
          ),
        ],
        if (previous != null) ...[
          const SizedBox(height: 8),
          Text('Previous Company: ${previous['company'] ?? '—'}'),
          Text('Role: ${previous['role'] ?? '—'}'),
          Text('Duration: ${previous['duration'] ?? '—'}'),
        ],
      ],
    );
  }

  Widget _buildClientSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Looking for: ${data['lookingFor'] ?? '—'}'),
        Text('Industry: ${data['industry'] ?? '—'}'),
      ],
    );
  }
}
