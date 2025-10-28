import 'package:dio/dio.dart';
import '../../storage/secure_storage.dart';

/// Injects the auth token into requests, except:
///  - when options.extra['noAuth'] == true
///  - or when calling recovery endpoints (paths containing 'Recover')
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);
  final SecureStorage _secureStorage;

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final noAuth = options.extra['noAuth'] == true;
    final isRecoveryCall = options.path.contains('Recover');

    if (!noAuth && !isRecoveryCall) {
      final token = await _secureStorage.readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['token'] = token;
      }
    }

    handler.next(options);
  }
}
