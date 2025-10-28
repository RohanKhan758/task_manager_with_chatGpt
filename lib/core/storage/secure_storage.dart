import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage for secrets (JWT, refresh token, etc).
class SecureStorage {
  SecureStorage._();
  static final SecureStorage instance = SecureStorage._();

  static const _kTokenKey = 'auth_token';

  // You can configure options per-platform if needed
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // ---- Token helpers ----
  Future<String?> readToken() => _storage.read(key: _kTokenKey);

  Future<void> writeToken(String token) =>
      _storage.write(key: _kTokenKey, value: token);

  Future<void> deleteToken() => _storage.delete(key: _kTokenKey);

  // ---- (Optional) generic helpers ----
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> clear() => _storage.deleteAll();
}
