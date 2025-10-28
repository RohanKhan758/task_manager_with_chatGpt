import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/user_profile.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_controller.dart';

/// Expose a separate provider focused on profile-only actions/state.
/// This keeps profile edits isolated from login/logout flows.
final profileControllerProvider =
StateNotifierProvider<ProfileController, ProfileState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return ProfileController(repo);
});

@immutable
class ProfileState {
  final bool isLoading;
  final UserProfile? profile;
  final String? error;

  const ProfileState({
    required this.isLoading,
    this.profile,
    this.error,
  });

  factory ProfileState.initial() => const ProfileState(isLoading: false);

  ProfileState copyWith({
    bool? isLoading,
    UserProfile? profile,
    String? error, // set '' to clear
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      error: error,
    );
  }
}

class ProfileController extends StateNotifier<ProfileState> {
  ProfileController(this._repo) : super(ProfileState.initial());

  final AuthRepository _repo;

  Future<UserProfile?> refresh() async {
    state = state.copyWith(isLoading: true, error: '');
    try {
      final p = await _repo.profileDetails();
      state = state.copyWith(isLoading: false, profile: p, error: '');
      return p;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  /// Accepts partial fields: {firstName, lastName, mobile, password}
  Future<UserProfile?> update(Map<String, dynamic> patch) async {
    state = state.copyWith(isLoading: true, error: '');
    try {
      final p = await _repo.profileUpdate(patch);
      state = state.copyWith(isLoading: false, profile: p, error: '');
      return p;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }
}
