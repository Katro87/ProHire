import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_profile.dart';

class UserProfileService {
  UserProfileService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<UserProfile> ensureProfile(String uid, {String? email, String? name}) async {
    final docRef = _firestore.collection('users').doc(uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'uid': uid,
        'name': (name ?? 'User').trim().isEmpty ? 'User' : (name ?? 'User').trim(),
        'email': (email ?? '').trim(),
        'role': null,
        'bio': '',
        'skills': <String>[],
        'currency': 'USD',
        'profileComplete': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      final data = doc.data() ?? <String, dynamic>{};
      final updates = <String, dynamic>{};
      if (data['uid'] == null) updates['uid'] = uid;
      if ((data['name'] as String?)?.trim().isEmpty ?? true) {
        updates['name'] = (name ?? 'User').trim().isEmpty ? 'User' : (name ?? 'User').trim();
      }
      if ((data['email'] as String?)?.trim().isEmpty ?? true) {
        updates['email'] = (email ?? '').trim();
      }
      if (!data.containsKey('role')) updates['role'] = null;
      if (!data.containsKey('bio')) updates['bio'] = '';
      if (!data.containsKey('skills')) updates['skills'] = <String>[];
      if (!data.containsKey('profileComplete')) updates['profileComplete'] = false;
      if (updates.isNotEmpty) {
        updates['updatedAt'] = FieldValue.serverTimestamp();
        await docRef.set(updates, SetOptions(merge: true));
      }
    }

    final ensured = await docRef.get();
    return UserProfile.fromDoc(ensured);
  }

  Future<UserProfile?> fetchProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromDoc(doc);
  }

  Stream<UserProfile?> watchProfile(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromDoc(doc);
    });
  }

  Future<bool> isProfileComplete(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return (doc.data()?['profileComplete'] as bool?) ?? false;
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _firestore.collection('users').doc(profile.uid).set(
          profile.toMap(),
          SetOptions(merge: true),
        );
  }

  Future<List<UserProfile>> fetchProfessionals() async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'professional')
        .where('profileComplete', isEqualTo: true)
        .get();

    return snapshot.docs.map(UserProfile.fromDoc).toList();
  }

  Future<List<UserProfile>> searchProfessionals(String keyword) async {
    final query = keyword.trim().toLowerCase();
    final profiles = await fetchProfessionals();
    if (query.isEmpty) return profiles;

    return profiles.where((profile) {
      final profileSkills = ((profile.professionalData?['skills'] as List?)
                  ?.map((e) => e.toString().toLowerCase())
                  .toList() ??
              <String>[]) +
          ((profile.clientData?['skills'] as List?)
                  ?.map((e) => e.toString().toLowerCase())
                  .toList() ??
              <String>[]);

      return profile.name.toLowerCase().contains(query) ||
          profile.bio.toLowerCase().contains(query) ||
          profileSkills.any((skill) => skill.contains(query));
    }).toList();
  }

  Future<void> seedDummyProfessionalsIfEmpty() async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'professional')
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) return;

    final batch = _firestore.batch();
    final now = FieldValue.serverTimestamp();

    final dummyUsers = <Map<String, dynamic>>[
      {
        'uid': 'seed_pro_1',
        'name': 'David Plumber',
        'email': 'david.plumber@example.com',
        'role': 'professional',
        'bio': 'Reliable plumbing repair and maintenance expert.',
        'skills': ['Pipe Repair', 'Drain Cleaning', 'Water Heater'],
        'profileComplete': true,
        'companyName': 'New York',
        'currency': 'USD',
        'professionalData': {
          'title': 'Plumber',
          'category': 'plumber',
          'type': 'trade',
          'skills': ['Pipe Repair', 'Drain Cleaning', 'Water Heater'],
          'experienceLevel': 'Expert',
          'hourlyRate': 45,
          'rating': 4.8,
          'reviewCount': 122,
        }
      },
      {
        'uid': 'seed_pro_2',
        'name': 'Ella Electric',
        'email': 'ella.electric@example.com',
        'role': 'professional',
        'bio': 'Licensed electrician for homes and offices.',
        'skills': ['Wiring', 'Panel Upgrade', 'Lighting'],
        'profileComplete': true,
        'companyName': 'Austin',
        'currency': 'USD',
        'professionalData': {
          'title': 'Electrician',
          'category': 'electrician',
          'type': 'trade',
          'skills': ['Wiring', 'Panel Upgrade', 'Lighting'],
          'experienceLevel': 'Intermediate',
          'hourlyRate': 50,
          'rating': 4.7,
          'reviewCount': 89,
        }
      },
      {
        'uid': 'seed_pro_3',
        'name': 'Nora Carpenter',
        'email': 'nora.carpenter@example.com',
        'role': 'professional',
        'bio': 'Custom carpentry and furniture build specialist.',
        'skills': ['Cabinet', 'Framing', 'Furniture'],
        'profileComplete': true,
        'companyName': 'Seattle',
        'currency': 'USD',
        'professionalData': {
          'title': 'Carpenter',
          'category': 'carpenter',
          'type': 'trade',
          'skills': ['Cabinet', 'Framing', 'Furniture'],
          'experienceLevel': 'Expert',
          'hourlyRate': 55,
          'rating': 4.9,
          'reviewCount': 140,
        }
      },
      {
        'uid': 'seed_pro_4',
        'name': 'Sam UI Designer',
        'email': 'sam.ui@example.com',
        'role': 'professional',
        'bio': 'Mobile and web UI designer.',
        'skills': ['Figma', 'UI Design', 'Prototyping'],
        'profileComplete': true,
        'companyName': 'Remote',
        'currency': 'USD',
        'professionalData': {
          'title': 'UI Designer',
          'category': 'designer',
          'type': 'freelancer',
          'skills': ['Figma', 'UI Design', 'Prototyping'],
          'experienceLevel': 'Intermediate',
          'hourlyRate': 40,
          'rating': 4.6,
          'reviewCount': 63,
        }
      },
      {
        'uid': 'seed_pro_5',
        'name': 'Maya Flutter Dev',
        'email': 'maya.flutter@example.com',
        'role': 'professional',
        'bio': 'Flutter developer building clean mobile apps.',
        'skills': ['Flutter', 'Firebase', 'Dart'],
        'profileComplete': true,
        'companyName': 'Remote',
        'currency': 'USD',
        'professionalData': {
          'title': 'Flutter Developer',
          'category': 'developer',
          'type': 'freelancer',
          'skills': ['Flutter', 'Firebase', 'Dart'],
          'experienceLevel': 'Expert',
          'hourlyRate': 65,
          'rating': 4.9,
          'reviewCount': 154,
        }
      },
    ];

    for (final user in dummyUsers) {
      final ref = _firestore.collection('users').doc(user['uid'] as String);
      batch.set(ref, {
        ...user,
        'createdAt': now,
        'updatedAt': now,
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }
}
