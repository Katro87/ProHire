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
  final String? userName;

  const AuthResult({
    required this.isSuccess,
    required this.errorCase,
    required this.message,
    this.userName,
  });

  const AuthResult.success({required String message, String? userName})
      : this(
          isSuccess: true,
          errorCase: AuthErrorCase.none,
          message: message,
          userName: userName,
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
          message: 'Password must be at least 6 characters',
        );
      case _ when password != confirmPassword:
        return const AuthResult.failure(
          errorCase: AuthErrorCase.passwordsDoNotMatch,
          message: 'Passwords do not match',
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

      final syncedName = await _ensureUserProfile(
        user: credential.user,
        fallbackName: resolvedName,
      );

      if (credential.user != null) {
        print('LOGIN SUCCESS: uid = ${credential.user!.uid}');
      }

      return AuthResult.success(message: 'Account created successfully', userName: syncedName);
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

      if (credential.user != null) {
        print('LOGIN SUCCESS: uid = ${credential.user!.uid}');
      }

      return AuthResult.success(
        message: 'Login successful',
        userName: credential.user?.displayName,
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
        message: 'Invalid email format',
      );
    }

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const AuthResult.success(message: 'Password reset email sent');
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
        final syncedName = await _ensureUserProfile(user: credential.user);
        if (credential.user != null) {
          print('LOGIN SUCCESS: uid = ${credential.user!.uid}');
        }
        return AuthResult.success(message: 'Google sign-in successful', userName: syncedName);
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
      final syncedName = await _ensureUserProfile(user: userCredential.user);

      if (userCredential.user != null) {
        print('LOGIN SUCCESS: uid = ${userCredential.user!.uid}');
      }

      return AuthResult.success(message: 'Google sign-in successful', userName: syncedName);
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
          message: 'Invalid email format',
        );
      case 'user-not-found':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.userNotFound,
          message: 'No account found with this email',
        );
      case 'wrong-password':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.wrongPassword,
          message: 'Incorrect password',
        );
      case 'weak-password':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.weakPassword,
          message: 'Password must be at least 6 characters',
        );
      case 'network-request-failed':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.network,
          message: 'Check your internet connection',
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

  Future<String> _ensureUserProfile({
    required User? user,
    String? fallbackName,
  }) async {
    if (user == null) return 'User';

    try {
      final doc = _firestore.collection('users').doc(user.uid);
      final snapshot = await doc.get();
      print('FIRESTORE USER FETCHED');

      final resolvedName = _resolveDisplayName(user.email ?? '', fallbackName ?? user.displayName);

      if (!snapshot.exists) {
        await doc.set({
          'uid': user.uid,
          'name': resolvedName,
          'email': user.email,
          'role': null,
          'bio': '',
          'skills': <String>[],
          'profileComplete': false,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        print('USER CREATED IN FIRESTORE');
      } else {
        final data = snapshot.data() ?? <String, dynamic>{};
        final existingName = (data['name'] as String?)?.trim() ?? '';
        final existingEmail = (data['email'] as String?)?.trim() ?? '';

        if (existingName.isEmpty ||
            existingEmail.isEmpty ||
            data['uid'] == null ||
            !data.containsKey('role') ||
            !data.containsKey('bio') ||
            !data.containsKey('skills')) {
          await doc.set({
            'uid': user.uid,
            'name': existingName.isEmpty ? resolvedName : existingName,
            'email': existingEmail.isEmpty ? user.email : existingEmail,
            if (!data.containsKey('role')) 'role': null,
            if (!data.containsKey('bio')) 'bio': '',
            if (!data.containsKey('skills')) 'skills': <String>[],
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }

        return existingName.isEmpty ? resolvedName : existingName;
      }
      return resolvedName;
    } catch (e, stack) {
      debugPrint('AUTH ERROR: firestore profile sync failed: $e');
      debugPrintStack(stackTrace: stack);
      return _resolveDisplayName(user.email ?? '', fallbackName ?? user.displayName);
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
