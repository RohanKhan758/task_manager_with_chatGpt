import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Mirrors your backend's Profile entity.
/// Example payloads from the API include:
/// { "_id": "...", "email": "...", "firstName": "...", "lastName": "...",
///   "mobile": "017...", "createdDate": "2024-01-27T06:16:59.371Z" }
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(name: '_id') required String id,
    required String email,
    String? firstName,
    String? lastName,
    String? mobile,

    /// Some sample responses showed `password` echoed back.
    /// We keep it optional; usually you should not expose/store it on device.
    String? password,

    /// ISO string from server -> DateTime here
    @JsonKey(name: 'createdDate') DateTime? createdDate,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
