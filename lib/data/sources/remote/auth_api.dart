import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failures.dart';
import '../../../core/constants/api_paths.dart';

import '../../models/auth_credentials.dart';
import '../../models/auth_token.dart';
import '../../models/user_profile.dart';

/// Auth & profile endpoints
class AuthApi {
  AuthApi({Dio? dio}) : _dio = dio ?? DioClient.create();
  final Dio _dio;

  // ---------- Auth ----------
  /// POST /Registration
  Future<UserProfile> register(AuthCredentials body) async {
    try {
      final res = await _dio.post(ApiPaths.registration, data: body.toJson());
      final data = res.data is Map ? res.data['data'] : null;
      if (data is Map<String, dynamic>) return UserProfile.fromJson(data);
      if (res.data is Map<String, dynamic>) {
        return UserProfile.fromJson(res.data as Map<String, dynamic>);
      }
      throw const UnknownFailure(message: 'Unexpected registration response');
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  /// POST /Login  -> { token: "<JWT>" } (shape can vary)
  Future<AuthToken> login(AuthCredentials body) async {
    try {
      final res = await _dio.post(ApiPaths.login, data: body.toJson());

      if (res.data is Map && (res.data as Map).containsKey('token')) {
        return AuthToken(token: (res.data as Map)['token'] as String);
      }
      final data = res.data is Map ? (res.data as Map)['data'] : null;
      if (data is Map && data['token'] is String) {
        return AuthToken(token: data['token'] as String);
      }
      if (res.data is String) return AuthToken(token: res.data as String);

      throw const UnknownFailure(message: 'Token not found in login response');
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  // ---------- Profile ----------
  /// GET /ProfileDetails
  Future<UserProfile> profileDetails() async {
    try {
      final res = await _dio.get(ApiPaths.profileDetails);
      final raw = res.data;

      if (raw is Map && raw['data'] != null) {
        final d = raw['data'];
        if (d is Map<String, dynamic>) return UserProfile.fromJson(d);
        if (d is List && d.isNotEmpty && d.first is Map<String, dynamic>) {
          return UserProfile.fromJson(d.first as Map<String, dynamic>);
        }
      }
      if (raw is Map<String, dynamic>) return UserProfile.fromJson(raw);

      throw const UnknownFailure(message: 'Unexpected profile response');
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  /// POST /ProfileUpdate
  Future<UserProfile> profileUpdate(Map<String, dynamic> body) async {
    try {
      final res = await _dio.post(ApiPaths.profileUpdate, data: body);
      final data = res.data is Map ? res.data['data'] : null;
      if (data is Map<String, dynamic>) return UserProfile.fromJson(data);
      if (res.data is Map<String, dynamic>) {
        return UserProfile.fromJson(res.data as Map<String, dynamic>);
      }
      throw const UnknownFailure(message: 'Unexpected profile update response');
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  // ---------- Password recovery (3-step) ----------
  /// STEP 1 — Send OTP: GET /RecoverVerifyEmail/:email
  Future<void> sendResetOtp(String email) async {
    try {
      await _dio.get(
        ApiPaths.recoverVerifyEmail(email),
        options: Options(extra: {'noAuth': true}), // skip token
      );
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  /// STEP 2 — Verify OTP: GET /RecoverVerifyOtp/:email/:otp
  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      await _dio.get(
        ApiPaths.recoverVerifyOtp(email, otp),
        options: Options(extra: {'noAuth': true}), // skip token
      );
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  /// STEP 3 — Reset password: POST /RecoverResetPassword
  /// Many servers expect form-urlencoded and may require cPassword.
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final form = FormData.fromMap({
        'email': email,
        'OTP': otp,
        'otp': otp, // be tolerant with casing
        'password': newPassword,
        'cPassword': newPassword, // some servers require confirm password
      });

      await _dio.post(
        ApiPaths.recoverResetPassword,
        data: form,
        options: Options(
          extra: {'noAuth': true}, // ensure no token on recovery APIs
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }
}
