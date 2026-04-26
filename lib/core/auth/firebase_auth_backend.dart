import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthErrorCase {
  none,
  invalidEmail,
  invalidPhoneNumber,
  weakPassword,
  passwordsDoNotMatch,
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
  smsCodeInvalid,
  smsCodeExpired,
  smsQuotaExceeded,
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

  ConfirmationResult? _webConfirmationResult;

  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  Future<AuthResult> signUp({
    required String displayName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (displayName.trim().isEmpty) {
      return const AuthResult.failure(
        errorCase: AuthErrorCase.unknown,
        message: 'Name is required.',
      );
    }
    switch (true) {
      case _ when email.trim().isEmpty:
        return const AuthResult.failure(
          errorCase: AuthErrorCase.emptyEmail,
          message: 'Email is required.',
        );
      case _ when !_emailRegex.hasMatch(email.trim()):
        return const AuthResult.failure(
          errorCase: AuthErrorCase.invalidEmail,
          message: 'Please enter a valid email address.',
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
          message: 'Password must be at least 6 characters long.',
        );
      case _ when password != confirmPassword:
        return const AuthResult.failure(
          errorCase: AuthErrorCase.passwordsDoNotMatch,
          message: 'Password and Confirm Password do not match.',
        );
      default:
        break;
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(displayName.trim());
      }

      await _ensureUserProfile(
        user: credential.user,
        role: 'client',
        displayName: displayName.trim(),
      );

      return const AuthResult.success(message: 'Account created successfully.');
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseAuthException(e, isLogin: false);
    } catch (_) {
      return const AuthResult.failure(
        errorCase: AuthErrorCase.unknown,
        message: 'Unexpected error occurred. Please try again.',
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

      await _ensureUserProfile(user: credential.user, role: 'client');

      return const AuthResult.success(message: 'Login successful.');
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseAuthException(e, isLogin: true);
    } catch (_) {
      return const AuthResult.failure(
        errorCase: AuthErrorCase.unknown,
        message: 'Unexpected error occurred. Please try again.',
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
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseAuthException(e, isLogin: true);
    } catch (_) {
      return const AuthResult.failure(
        errorCase: AuthErrorCase.unknown,
        message: 'Unable to send reset email. Please try again.',
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
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseAuthException(e, isLogin: true);
    } catch (_) {
      return const AuthResult.failure(
        errorCase: AuthErrorCase.unknown,
        message: 'Google sign-in failed. Please try again.',
      );
    }
  }

  Future<AuthResult> sendPhoneOtp({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(AuthResult failure) onFailed,
    void Function()? onAutoVerified,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (phoneNumber.trim().isEmpty) {
      return const AuthResult.failure(
        errorCase: AuthErrorCase.invalidPhoneNumber,
        message: 'Phone number is required.',
      );
    }

    try {
      final isAllowed = await _isPhoneLoginAllowed(phoneNumber.trim());
      if (!isAllowed) {
        return const AuthResult.failure(
          errorCase: AuthErrorCase.userNotFound,
          message: 'No account found for this phone number.',
        );
      }

      if (kIsWeb) {
        final verifier = RecaptchaVerifier(
          auth: FirebaseAuthPlatform.instance,
          size: RecaptchaVerifierSize.normal,
          theme: RecaptchaVerifierTheme.light,
        );
        _webConfirmationResult =
            await _auth.signInWithPhoneNumber(phoneNumber.trim(), verifier);
        onCodeSent(_webConfirmationResult!.verificationId, null);
        return const AuthResult.success(message: 'Verification code sent.');
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber.trim(),
        timeout: timeout,
        verificationCompleted: (credential) async {
          final userCredential = await _auth.signInWithCredential(credential);
          await _ensureUserProfile(user: userCredential.user, role: 'client');
          onAutoVerified?.call();
        },
        verificationFailed: (exception) {
          onFailed(_mapFirebaseAuthException(exception, isLogin: true));
        },
        codeSent: (verificationId, resendToken) {
          onCodeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (_) {},
      );

      return const AuthResult.success(message: 'Verification code sent.');
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseAuthException(e, isLogin: true);
    } catch (_) {
      return const AuthResult.failure(
        errorCase: AuthErrorCase.unknown,
        message: 'Unable to send code. Please try again.',
      );
    }
  }

  Future<AuthResult> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    if (smsCode.trim().length < 4) {
      return const AuthResult.failure(
        errorCase: AuthErrorCase.smsCodeInvalid,
        message: 'Enter the code you received via SMS.',
      );
    }

    try {
      UserCredential credential;
      if (kIsWeb) {
        if (_webConfirmationResult == null) {
          return const AuthResult.failure(
            errorCase: AuthErrorCase.unknown,
            message: 'Start phone verification first.',
          );
        }
        credential = await _webConfirmationResult!.confirm(smsCode.trim());
      } else {
        final phoneCredential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode.trim(),
        );
        credential = await _auth.signInWithCredential(phoneCredential);
      }

      await _ensureUserProfile(user: credential.user, role: 'client');
      return const AuthResult.success(message: 'Phone verification successful.');
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseAuthException(e, isLogin: true);
    } catch (_) {
      return const AuthResult.failure(
        errorCase: AuthErrorCase.unknown,
        message: 'Unable to verify the code. Please try again.',
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
      case 'invalid-phone-number':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.invalidPhoneNumber,
          message: 'Invalid phone number. Include country code.',
        );
      case 'invalid-verification-code':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.smsCodeInvalid,
          message: 'Invalid verification code. Try again.',
        );
      case 'session-expired':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.smsCodeExpired,
          message: 'Code expired. Request a new one.',
        );
      case 'quota-exceeded':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.smsQuotaExceeded,
          message: 'SMS limit reached, try again later.',
        );
      case 'too-many-requests':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.tooManyRequests,
          message: 'Too many attempts. Please wait and try again.',
        );
      case 'app-not-authorized':
      case 'missing-client-identifier':
        return const AuthResult.failure(
          errorCase: AuthErrorCase.unknown,
          message: 'Phone auth is not authorized for this app yet.',
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
            : (isLogin
                ? 'Unable to login right now. Please try again.'
                : 'Unable to sign up right now. Please try again.');
        return AuthResult.failure(
          errorCase: AuthErrorCase.unknown,
          message: fallback,
        );
    }
  }

  Future<void> _ensureUserProfile({
    required User? user,
    required String role,
    String? displayName,
  }) async {
    if (user == null) return;

    final doc = _firestore.collection('users').doc(user.uid);
    final snapshot = await doc.get();

    if (!snapshot.exists) {
      await doc.set({
        'role': role,
        'email': user.email,
        'phone': user.phoneNumber,
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
  }

  Future<bool> _isPhoneLoginAllowed(String phoneNumber) async {
    final snapshot = await _firestore
        .collection('users')
        .where('phone', isEqualTo: phoneNumber)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
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
