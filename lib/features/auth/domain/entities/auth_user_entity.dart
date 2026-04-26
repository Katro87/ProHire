import 'package:prohire/core/auth/firebase_auth_backend.dart';

class AuthUserEntity {
  final String id;
  final String email;
  final String? displayName;
  final String? role;

  const AuthUserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.role,
  });
}
