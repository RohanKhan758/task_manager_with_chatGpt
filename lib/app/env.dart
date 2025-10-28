import 'package:flutter/foundation.dart';

/// Central place for environment config (server URLs, flags, timeouts).
/// You can override values at build time using --dart-define, e.g.:
/// flutter run --dart-define=ENV=prod --dart-define=BASE_URL=http://35.73.30.144:2005/api/v1
///
/// Defaults are safe for local/dev.
class AppEnv {
  AppEnv._();

  /// Current environment label: dev | staging | prod (optional)
  static const String env =
  String.fromEnvironment('ENV', defaultValue: 'dev');

  /// Backend base URL (your API root)
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://35.73.30.144:2005/api/v1',
  );

  /// HTTP timeouts (ms)
  static const int connectTimeoutMs =
  int.fromEnvironment('CONNECT_TIMEOUT_MS', defaultValue: 10000);
  static const int receiveTimeoutMs =
  int.fromEnvironment('RECEIVE_TIMEOUT_MS', defaultValue: 15000);

  /// Feature flags (you can toggle these by dart-define later)
  static const bool enableLogging =
  bool.fromEnvironment('ENABLE_LOGGING', defaultValue: kDebugMode);
  static const bool enableMockData =
  bool.fromEnvironment('ENABLE_MOCK_DATA', defaultValue: false);

  /// Helper: print a one-line summary in debug logs.
  static String summary() {
    return 'ENV=$env • baseUrl=$baseUrl • timeouts=($connectTimeoutMs/$receiveTimeoutMs) • logging=$enableLogging • mock=$enableMockData';
  }
}
