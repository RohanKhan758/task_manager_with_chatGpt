import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token.freezed.dart';
part 'auth_token.g.dart';

/// Represents the API's login response body that contains the JWT token.
/// Example: { "token": "eyJhbGciOi..." }
@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    required String token,
  }) = _AuthToken;

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);
}
