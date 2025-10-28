import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';

import 'failures.dart';

/// Maps any thrown error (Dio, Socket, etc.) into a typed [Failure]
/// so the rest of the app doesn’t worry about raw exceptions.
class ErrorMapper {
  ErrorMapper._();

  /// Main entry: call this in repositories `catch (e, s) { ... }`.
  static Failure from(Object error, [StackTrace? stackTrace]) {
    if (error is Failure) return error;

    if (error is DioException) {
      return _fromDio(error, stackTrace);
    }

    if (error is SocketException) {
      return NetworkFailure(message: 'No internet connection', cause: error, stackTrace: stackTrace);
    }

    if (error is TimeoutException) {
      return TimeoutFailure(message: 'Request timed out', cause: error, stackTrace: stackTrace);
    }

    // Fallback
    return UnknownFailure(cause: error, stackTrace: stackTrace);
  }

  /// Convert a DioException to a specific Failure.
  static Failure _fromDio(DioException e, [StackTrace? s]) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(message: 'Network timeout', cause: e, stackTrace: s);

      case DioExceptionType.cancel:
      // Treat cancel as Unknown (usually user-driven); adjust if needed
        return UnknownFailure(message: 'Request cancelled', cause: e, stackTrace: s);

      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
        return NetworkFailure(message: 'Network error', cause: e, stackTrace: s);

      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        final data = e.response?.data;

        if (status == 401) {
          return UnauthorizedFailure(errorBody: data, cause: e, stackTrace: s);
        }
        if (status == 404) {
          return NotFoundFailure(errorBody: data, cause: e, stackTrace: s);
        }

        // Common 4xx/5xx
        final msg = _extractMessage(data) ?? 'Server error ($status)';
        return ApiFailure(
          message: msg,
          statusCode: status,
          errorBody: data,
          cause: e,
          stackTrace: s,
        );

      case DioExceptionType.unknown:
      // Could be SocketException under the hood
        final underlying = e.error;
        if (underlying is SocketException) {
          return NetworkFailure(message: 'No internet connection', cause: e, stackTrace: s);
        }
        return UnknownFailure(message: e.message, cause: e, stackTrace: s);
    }
  }

  /// Try to extract a readable message field from server JSON.
  /// Accepts common shapes like:
  /// { "status": "fail", "message": "..."} or { "error": "..."}.
  static String? _extractMessage(dynamic body) {
    try {
      if (body is Map) {
        final candidates = ['message', 'error', 'msg', 'detail'];
        for (final key in candidates) {
          final v = body[key];
          if (v is String && v.trim().isNotEmpty) return v.trim();
        }
      }
      if (body is String && body.trim().isNotEmpty) return body.trim();
      return null;
    } catch (_) {
      return null;
    }
  }
}
