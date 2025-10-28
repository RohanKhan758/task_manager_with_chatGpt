import 'package:flutter/foundation.dart';

import '../../core/constants/app_keys.dart';
import '../../core/errors/error_mapper.dart';
import '../../core/errors/failures.dart';
import '../../core/storage/secure_storage.dart';

import '../models/auth_credentials.dart';
import '../models/auth_token.dart';
import '../models/user_profile.dart';
import '../sources/remote/auth_api.dart';

/// Handles auth flows + token persistence.
class AuthRepository {
  AuthRepository({
    AuthApi? api,
    SecureStorage? secureStorage,
  })  : _api = api ?? AuthApi(),
        _secure = secureStorage ?? SecureStorage.instance;

  final AuthApi _api;
  final SecureStorage _secure;

  /// Register a new user. Returns the created profile.
  Future<UserProfile> register(AuthCredentials creds) async {
    try {
      final profile = await _api.register(creds);
      return profile;
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  /// Login → saves token securely → returns it.
  Future<AuthToken> login(AuthCredentials creds) async {
    try {
      final token = await _api.login(creds);
      await _secure.write(AppKeys.accessToken, token.token);
      if (kDebugMode) {
        // ignore: avoid_print
        final preview = token.token.length > 10 ? token.token.substring(0, 10) : token.token;
        print('AuthRepository: token saved ($preview...)');
      }
      return token;
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  /// Remove token and any other sensitive values.
  Future<void> logout() async {
    try {
      await _secure.delete(AppKeys.accessToken);
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  /// Check whether a token is present.
  Future<bool> isLoggedIn() async {
    try {
      final token = await _secure.read(AppKeys.accessToken);
      return token != null && token.isNotEmpty;
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  /// Return the current token (if any).
  Future<String?> getToken() async {
    try {
      return await _secure.read(AppKeys.accessToken);
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  /// Fetch profile for the currently logged-in user.
  Future<UserProfile> profileDetails() async {
    try {
      return await _api.profileDetails();
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  /// Update profile; send partial fields like {firstName, lastName, mobile, password}
  Future<UserProfile> profileUpdate(Map<String, dynamic> patch) async {
    try {
      return await _api.profileUpdate(patch);
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  Future<void> sendResetOtp(String email) async {
    try {
      await _api.sendResetOtp(email);
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _api.resetPassword(email: email, otp: otp, newPassword: newPassword);
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }
}
