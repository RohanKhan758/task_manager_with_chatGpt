import 'package:dio/dio.dart';
import 'package:task_manager/app/env.dart'; // <-- fix path

import 'interceptors/auth_interceptor.dart';
// If you don't have a custom logger, use Dio's built-in LogInterceptor
// import 'interceptors/log_interceptor.dart'; // (only if you created AppLogInterceptor)
import '../storage/secure_storage.dart';

class DioClient {
  DioClient._();

  static Dio create() {
    final baseOptions = BaseOptions(
      baseUrl: AppEnv.baseUrl, // e.g. http://35.73.30.144:2005/api/v1
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    final dio = Dio(baseOptions);

    dio.interceptors.addAll([
      AuthInterceptor(SecureStorage.instance),
      // If you have your own interceptor class, use it. Otherwise use Dio's default:
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
      // AppLogInterceptor(), // <-- use this only if you actually defined it
    ]);

    return dio;
  }
}
