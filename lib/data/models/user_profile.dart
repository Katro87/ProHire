import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String role; // client or professional
  final String bio;
  final DateTime? dob;
  final String? companyName;
  final String currency;
  final String? profileImageUrl;
  final Map<String, dynamic>? professionalData;
  final Map<String, dynamic>? clientData;
  final bool profileComplete;

  const UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.bio,
    required this.dob,
    required this.companyName,
    required this.currency,
    required this.profileImageUrl,
    required this.professionalData,
    required this.clientData,
    required this.profileComplete,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'bio': bio,
      'dob': dob != null ? Timestamp.fromDate(dob!) : null,
      'companyName': companyName,
      'currency': currency,
      'profileImageUrl': profileImageUrl,
      'professionalData': professionalData,
      'clientData': clientData,
      'profileComplete': profileComplete,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static UserProfile fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserProfile(
      uid: doc.id,
      name: data['name'] as String? ?? 'User',
      email: data['email'] as String? ?? '',
      role: data['role'] as String? ?? 'client',
      bio: data['bio'] as String? ?? '',
      dob: (data['dob'] as Timestamp?)?.toDate(),
      companyName: data['companyName'] as String?,
      currency: data['currency'] as String? ?? 'USD',
      profileImageUrl: data['profileImageUrl'] as String?,
      professionalData: data['professionalData'] as Map<String, dynamic>?,
      clientData: data['clientData'] as Map<String, dynamic>?,
      profileComplete: data['profileComplete'] as bool? ?? false,
    );
  }
}
