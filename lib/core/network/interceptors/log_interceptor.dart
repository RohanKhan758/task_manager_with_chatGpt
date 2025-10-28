import 'package:dio/dio.dart';

/// Minimal, readable logging interceptor.
/// Toggle with `enabled` (wired from AppEnv.enableLogging).
class LogInterceptorX extends Interceptor {
  final bool enabled;
  LogInterceptorX({this.enabled = true});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!enabled) return handler.next(options);
    final m = StringBuffer()
      ..writeln('➡️  [${options.method}] ${options.baseUrl}${options.path}')
      ..writeln('Headers: ${options.headers}')
      ..writeln('Query: ${options.queryParameters}')
      ..writeln('Data: ${_safeBody(options.data)}');
    // ignore: avoid_print
    print(m.toString());
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!enabled) return handler.next(response);
    final m = StringBuffer()
      ..writeln('✅ [${response.requestOptions.method}] '
          '${response.requestOptions.baseUrl}${response.requestOptions.path}')
      ..writeln('Status: ${response.statusCode}')
      ..writeln('Data: ${_safeBody(response.data)}');
    // ignore: avoid_print
    print(m.toString());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!enabled) return handler.next(err);
    final req = err.requestOptions;
    final m = StringBuffer()
      ..writeln('❌ [${req.method}] ${req.baseUrl}${req.path}')
      ..writeln('Status: ${err.response?.statusCode}')
      ..writeln('Error: ${err.error}')
      ..writeln('Message: ${err.message}')
      ..writeln('Response: ${_safeBody(err.response?.data)}');
    // ignore: avoid_print
    print(m.toString());
    handler.next(err);
  }

  String _safeBody(dynamic data) {
    if (data == null) return 'null';
    try {
      final s = data.toString();
      return s.length > 1200 ? '${s.substring(0, 1200)}…(truncated)' : s;
    } catch (_) {
      return '<non-printable>';
    }
  }
}
