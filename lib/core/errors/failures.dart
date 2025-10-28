/// Unified error types the UI/repositories can work with
/// instead of dealing with raw exceptions or HTTP codes.
///
/// Pattern you can use in code:
///   final Failure f = Failure.api(message: 'Invalid creds', statusCode: 401);
///   if (f is UnauthorizedFailure) { ... }

abstract class Failure implements Exception {
  const Failure({this.message, this.cause, this.stackTrace});

  /// Human-readable message (safe to show in UI if needed).
  final String? message;

  /// Original low-level error (DioException, SocketException, etc.).
  final Object? cause;

  /// Where it happened (optional).
  final StackTrace? stackTrace;

  @override
  String toString() => '${runtimeType}: ${message ?? 'Failure'}';
}

/// The server returned a response but it indicates failure (HTTP 4xx/5xx).
class ApiFailure extends Failure {
  const ApiFailure({
    String? message,
    this.statusCode,
    this.errorBody,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(message: message, cause: cause, stackTrace: stackTrace);

  /// HTTP status code (e.g., 400, 401, 500…).
  final int? statusCode;

  /// Raw response body (optional; useful for debugging).
  final Object? errorBody;
}

/// No internet, DNS failure, or the connection dropped.
class NetworkFailure extends Failure {
  const NetworkFailure({
    String? message,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(message: message, cause: cause, stackTrace: stackTrace);
}

/// The operation exceeded a timeout threshold.
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String? message,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(message: message, cause: cause, stackTrace: stackTrace);
}

/// The request was invalid (client-side validation or 422/400 semantics).
class ValidationFailure extends Failure {
  const ValidationFailure({
    String? message,
    this.fieldErrors,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(message: message, cause: cause, stackTrace: stackTrace);

  /// Optional field-level messages: { 'email': 'Invalid', 'password': 'Too short' }
  final Map<String, String>? fieldErrors;
}

/// The user is not authenticated (HTTP 401).
class UnauthorizedFailure extends ApiFailure {
  const UnauthorizedFailure({
    String? message,
    Object? cause,
    StackTrace? stackTrace,
    Object? errorBody,
  }) : super(
    message: message ?? 'Unauthorized',
    statusCode: 401,
    cause: cause,
    stackTrace: stackTrace,
    errorBody: errorBody,
  );
}

/// The requested resource was not found (HTTP 404).
class NotFoundFailure extends ApiFailure {
  const NotFoundFailure({
    String? message,
    Object? cause,
    StackTrace? stackTrace,
    Object? errorBody,
  }) : super(
    message: message ?? 'Not found',
    statusCode: 404,
    cause: cause,
    stackTrace: stackTrace,
    errorBody: errorBody,
  );
}

/// A generic catch-all for unexpected errors.
class UnknownFailure extends Failure {
  const UnknownFailure({
    String? message,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(message: message ?? 'Something went wrong', cause: cause, stackTrace: stackTrace);
}
