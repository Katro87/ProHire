import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String profession;
  final double balance;
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
    this.profession = 'Not set',
    this.balance = 0,
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
      'profession': profession,
      'balance': balance,
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
    final data = doc.data() ?? <String, dynamic>{};

    final uid = doc.id;
    final name = _asString(data['name'], fallback: 'Unknown User');
    final email = _asString(data['email']);
    final profession = _asString(data['profession'], fallback: 'Not set');
    final balance = _asDouble(data['balance']);
    final role = _asString(data['role'], fallback: 'client');
    final bio = _asString(data['bio']);
    final companyName = _asNullableString(data['companyName']);
    final currency = _asString(data['currency'], fallback: 'USD');
    final profileImageUrl = _asNullableString(data['profileImageUrl']);

    final rawProfessionalData = data['professionalData'];
    final professionalData = rawProfessionalData is Map
        ? Map<String, dynamic>.from(rawProfessionalData)
        : null;

    final rawClientData = data['clientData'];
    final clientData = rawClientData is Map
        ? Map<String, dynamic>.from(rawClientData)
        : null;

    return UserProfile(
      uid: uid,
      name: name,
      email: email,
      profession: profession,
      balance: balance,
      role: role,
      bio: bio,
      dob: (data['dob'] as Timestamp?)?.toDate(),
      companyName: companyName,
      currency: currency,
      profileImageUrl: profileImageUrl,
      professionalData: professionalData,
      clientData: clientData,
      profileComplete: data['profileComplete'] as bool? ?? false,
    );
  }

  static String _asString(dynamic value, {String fallback = ''}) {
    final parsed = value?.toString().trim() ?? '';
    return parsed.isEmpty ? fallback : parsed;
  }

  static String? _asNullableString(dynamic value) {
    final parsed = value?.toString().trim() ?? '';
    return parsed.isEmpty ? null : parsed;
  }

  static double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
