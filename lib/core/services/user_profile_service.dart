import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_profile.dart';

class UserProfileService {
  UserProfileService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

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
}
