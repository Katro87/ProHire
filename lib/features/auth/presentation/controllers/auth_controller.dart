import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final Ref _ref;
  AuthController(this._ref) : super(const AuthState());

  // Logic will be added here
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
