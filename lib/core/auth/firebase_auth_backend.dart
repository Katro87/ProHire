import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthErrorCase {
  none,
  invalidEmail,
  weakPassword,
  passwordsDoNotMatch,
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
  tooManyRequests,
  emptyEmail,
  emptyPassword,
  emptyConfirmPassword,
  network,
  cancelled,
  unknown,
}

class AuthResult {
  final bool isSuccess;
  final AuthErrorCase errorCase;
  final String message;

  const AuthResult({
    required this.isSuccess,
    required this.errorCase,
    required this.message,
  });

  const AuthResult.success({required String message})
      : this(
          isSuccess: true,
          errorCase: AuthErrorCase.none,
          message: message,
        );

  const AuthResult.failure({required AuthErrorCase errorCase, required String message})
      : this(
          isSuccess: false,
          errorCase: errorCase,
          message: message,
        );
}

class FirebaseAuthBackend {
  FirebaseAuthBackend({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  static final RegExp _emailRegex = RegExp(r'.+@.+');

  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required String displayName,
  }) async {
    switch (true) {
      case _ when displayName.trim().isEmpty:
        return const AuthResult.failure(
          errorCase: AuthErrorCase.unknown,
          message: 'Full name is required.',
        );
      case _ when email.trim().isEmpty:
        return const AuthResult.failure(
          errorCase: AuthErrorCase.emptyEmail,
          message: 'Email is required.',
        );
      case _ when !_emailRegex.hasMatch(email.trim()):
        return const AuthResult.failure(
          errorCase: AuthErrorCase.invalidEmail,
          message: 'Invalid email format.',
        );
      case _ when password.isEmpty:
        return const AuthResult.failure(
          errorCase: AuthErrorCase.emptyPassword,
          message: 'Password is required.',
        );
      case _ when confirmPassword.isEmpty:
        return const AuthResult.failure(
          errorCase: AuthErrorCase.emptyConfirmPassword,
          message: 'Confirm password is required.',
        );
      case _ when password.length < 6:
        return const AuthResult.failure(
          errorCase: AuthErrorCase.weakPassword,
          message: 'Password too short.',
        );
      case _ when password != confirmPassword:
        return const AuthResult.failure(
          errorCase: AuthErrorCase.passwordsDoNotMatch,
          message: 'Passwords do not match.',
        );
      default:
        break;
    }

    final resolvedName = _resolveDisplayName(email, displayName);

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(resolvedName);
      }

      final profileSaved = await _ensureUserProfile(
        user: credential.user,
        role: 'client',
        displayName: resolvedName,
      );

      return AuthResult.success(
        message: profileSaved
            ? 'Account created successfully.'
            : 'Account created. Profile sync pending.',
      );
    } on FirebaseAuthException catch (e, stack) {
      debugPrint('AUTH ERROR: ${e.code} - ${e.message}');
      debugPrintStack(stackTrace: stack);
      return _mapFirebaseAuthException(e, isLogin: false);
    } catch (e, stack) {
      debugPrint('UNKNOWN ERROR: $e');
      debugPrintStack(stackTrace: stack);
      return AuthResult.failure(
        errorCase: AuthErrorCase.unknown,
        message: e.toString(),
      );
    }
  }

  Future<AuthResult> login({required String email, required String password}) async {
    switch (true) {
      case _ when email.trim().isEmpty:
        return const AuthResult.failure(
          errorCase: AuthErrorCase.emptyEmail,
          message: 'Email is required.',
        );
      case _ when !_emailRegex.hasMatch(email.trim()):
        return const AuthResult.failure(
          errorCase: AuthErrorCase.invalidEmail,
          message: 'Invalid email format.',
        );
      case _ when password.isEmpty:
        return const AuthResult.failure(
          errorCase: AuthErrorCase.emptyPassword,
          message: 'Password is required.',
        );
      default:
        break;
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final profileSaved = await _ensureUserProfile(user: credential.user, role: 'client');

      return AuthResult.success(
        message: profileSaved
            ? 'Login successful.'
            : 'Login successful. Profile sync pending.',
      );
    } on FirebaseAuthException catch (e, stack) {
      debugPrint('AUTH ERROR: ${e.code} - ${e.message}');
      debugPrintStack(stackTrace: stack);
      return _mapFirebaseAuthException(e, isLogin: true);
    } catch (e, stack) {
      debugPrint('UNKNOWN ERROR: $e');
      debugPrintStack(stackTrace: stack);
      return AuthResult.failure(
        errorCase: AuthErrorCase.unknown,
        message: e.toString(),
      );
    }
  }

  Future<AuthResult> sendPasswordReset({required String email}) async {
    if (email.trim().isEmpty) {
      return const AuthResult.failure(
        errorCase: AuthErrorCase.emptyEmail,
        message: 'Email is required to reset your password.',
      );
    }
    if (!_emailRegex.hasMatch(email.trim())) {
      return const AuthResult.failure(
        errorCase: AuthErrorCase.invalidEmail,
        message: 'Please enter a valid email address.',
      );
    }

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const AuthResult.success(message: 'Password reset email sent.');
    } on FirebaseAuthException catch (e, stack) {
      debugPrint('AUTH ERROR: ${e.code} - ${e.message}');
      debugPrintStack(stackTrace: stack);
      return _mapFirebaseAuthException(e, isLogin: true);
    } catch (e, stack) {
      debugPrint('UNKNOWN ERROR: $e');
      debugPrintStack(stackTrace: stack);
      return AuthResult.failure(
        errorCase: AuthErrorCase.unknown,
        message: e.toString(),
      );
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        final credential = await _auth.signInWithPopup(provider);
        await _ensureUserProfile(user: credential.user, role: 'client');
        return const AuthResult.success(message: 'Google sign-in successful.');
      }

      final user = await _googleSignIn.signIn();
      if (user == null) {
        return const AuthResult.failure(
          errorCase: AuthErrorCase.cancelled,
          message: 'Google sign-in cancelled.',
        );
      }

      final auth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      await _ensureUserProfile(user: userCredential.user, role: 'client');
      return const AuthResult.success(message: 'Google sign-in successful.');
    } on FirebaseAuthException catch (e, stack) {
      debugPrint('AUTH ERROR: ${e.code} - ${e.message}');
      debugPrintStack(stackTrace: stack);
      return _mapFirebaseAuthException(e, isLogin: true);
    } catch (e, stack) {
      debugPrint('UNKNOWN ERROR: $e');
      debugPrintStack(stackTrace: stack);
      return AuthResult.failure(
        errorCase: AuthErrorCase.unknown,
        message: e.toString(),
      );
    }
  }

  AuthResult _mapFirebaseAuthException(FirebaseAuthException exception, {required bool isLogin}) {
    switch (exception.code) {
      case 'operation-not-allowed':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.unknown,
          message: 'This sign-in method is not enabled yet.',
        );
      case 'user-disabled':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.unknown,
          message: 'This account is disabled. Contact support.',
        );
      case 'account-exists-with-different-credential':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.unknown,
          message: 'Use the original sign-in method for this account.',
        );
      case 'credential-already-in-use':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.unknown,
          message: 'This credential is already linked to another account.',
        );
      case 'invalid-credential':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.unknown,
          message: 'Invalid credentials. Please try again.',
        );
      case 'popup-blocked':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.unknown,
          message: 'Popup blocked. Allow popups and try again.',
        );
      case 'too-many-requests':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.tooManyRequests,
          message: 'Too many attempts. Please wait and try again.',
        );
      case 'email-already-in-use':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.emailAlreadyInUse,
          message: 'This email is already registered.',
        );
      case 'invalid-email':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.invalidEmail,
          message: 'Invalid email format.',
        );
      case 'user-not-found':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.userNotFound,
          message: 'No account found for this email.',
        );
      case 'wrong-password':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.wrongPassword,
          message: 'Wrong password entered.',
        );
      case 'weak-password':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.weakPassword,
          message: 'Password is too weak. Use at least 6 characters.',
        );
      case 'network-request-failed':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.network,
          message: 'Network error. Please try again.',
        );
      case 'popup-closed-by-user':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.cancelled,
          message: 'Sign-in popup closed before completing.',
        );
      default:
        final fallback = exception.message?.trim().isNotEmpty == true
            ? exception.message!.trim()
            : exception.code;
        return AuthResult.failure(
          errorCase: AuthErrorCase.unknown,
          message: fallback,
        );
    }
  }

  Future<bool> _ensureUserProfile({
    required User? user,
    required String role,
    String? displayName,
  }) async {
    if (user == null) return false;

    try {
      final doc = _firestore.collection('users').doc(user.uid);
      final snapshot = await doc.get();

      if (!snapshot.exists) {
        await doc.set({
          'role': role,
          'email': user.email,
          'displayName': displayName ?? user.displayName,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await doc.set({
          if ((displayName ?? '').isNotEmpty) 'displayName': displayName,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
      return true;
    } catch (e, stack) {
      debugPrint('AUTH ERROR: firestore profile sync failed: $e');
      debugPrintStack(stackTrace: stack);
      return false;
    }
  }

  String _resolveDisplayName(String email, String? displayName) {
    final trimmed = (displayName ?? '').trim();
    if (trimmed.isNotEmpty) return trimmed;
    final local = email.trim().split('@').first.trim();
    return local.isEmpty ? 'User' : local;
  }

  Future<void> updateUserRole(String role) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
