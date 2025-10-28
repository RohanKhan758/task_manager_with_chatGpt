import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/auth_credentials.dart';
import '../../../data/models/auth_token.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/auth_repository.dart';

/// ------------------------------
/// Providers
/// ------------------------------

/// Repository provider (so we can override with mocks in tests if needed)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Auth state (exposed to the whole app)
final authControllerProvider =
StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo);
});

/// ------------------------------
/// State
/// ------------------------------

@immutable
class AuthState {
  final bool isChecking; // true while we determine if a token exists
  final bool isSubmitting; // true while login/register/logout is in-flight
  final bool isLoggedIn;
  final String? token;
  final UserProfile? profile;
  final String? error;

  const AuthState({
    required this.isChecking,
    required this.isSubmitting,
    required this.isLoggedIn,
    this.token,
    this.profile,
    this.error,
  });

  factory AuthState.initial() => const AuthState(
    isChecking: true,
    isSubmitting: false,
    isLoggedIn: false,
    token: null,
    profile: null,
    error: null,
  );

  AuthState copyWith({
    bool? isChecking,
    bool? isSubmitting,
    bool? isLoggedIn,
    String? token,
    UserProfile? profile,
    String? error, // set to empty string to clear
  }) {
    return AuthState(
      isChecking: isChecking ?? this.isChecking,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
      profile: profile ?? this.profile,
      error: error,
    );
  }
}

/// ------------------------------
/// Controller
/// ------------------------------

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repo) : super(AuthState.initial()) {
    bootstrap();
  }

  final AuthRepository _repo;

  /// Called at startup to determine if we already have a token.
  Future<void> bootstrap() async {
    try {
      final ok = await _repo.isLoggedIn();
      final token = ok ? await _repo.getToken() : null;
      state = state.copyWith(
        isChecking: false,
        isLoggedIn: ok,
        token: token,
        error: '',
      );

      if (ok) {
        await fetchProfile(silent: true);
      }
    } catch (e) {
      state = state.copyWith(isChecking: false, isLoggedIn: false, error: e.toString());
    }
  }

  /// Login using email/password.
  Future<AuthToken?> login({required String email, required String password}) async {
    state = state.copyWith(isSubmitting: true, error: '');
    try {
      final token = await _repo.login(AuthCredentials(email: email, password: password));
      state = state.copyWith(
        isSubmitting: false,
        isLoggedIn: true,
        token: token.token,
        error: '',
      );
      // Optionally fetch profile right after login
      await fetchProfile(silent: true);
      return token;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, isLoggedIn: false, error: e.toString());
      return null;
    }
  }

  /// Logout and clear token.
  Future<void> logout() async {
    state = state.copyWith(isSubmitting: true, error: '');
    try {
      await _repo.logout();
      state = AuthState.initial().copyWith(isChecking: false, error: '');
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
    }
  }

  /// Registration -> (optionally) auto-login or prompt to login.
  Future<UserProfile?> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    String? mobile,
  }) async {
    state = state.copyWith(isSubmitting: true, error: '');
    try {
      // Your backend’s /Registration expects at least email/password.
      // We send extras if provided.
      final profile = await _repo.register(
        AuthCredentials(email: email, password: password),
      );

      // If you want auto-login here, call login(email, password).
      state = state.copyWith(isSubmitting: false, error: '', profile: profile);
      return profile;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return null;
    }
  }

  /// Fetch the current user profile.
  Future<UserProfile?> fetchProfile({bool silent = false}) async {
    if (!silent) state = state.copyWith(isSubmitting: true, error: '');
    try {
      final p = await _repo.profileDetails();
      state = state.copyWith(isSubmitting: false, profile: p, error: '');
      return p;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return null;
    }
  }

  /// Update profile fields.
  Future<UserProfile?> updateProfile(Map<String, dynamic> patch) async {
    state = state.copyWith(isSubmitting: true, error: '');
    try {
      final p = await _repo.profileUpdate(patch);
      state = state.copyWith(isSubmitting: false, profile: p, error: '');
      return p;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return null;
    }
  }

  Future<bool> sendResetOtp(String email) async {
    state = state.copyWith(isSubmitting: true, error: '');
    try {
      await _repo.sendResetOtp(email);
      state = state.copyWith(isSubmitting: false, error: '');
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return false;
    }
  }

  Future<bool> applyNewPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    state = state.copyWith(isSubmitting: true, error: '');
    try {
      await _repo.resetPassword(email: email, otp: otp, newPassword: newPassword);
      state = state.copyWith(isSubmitting: false, error: '');
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return false;
    }
  }
}
