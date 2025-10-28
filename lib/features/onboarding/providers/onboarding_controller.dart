import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_keys.dart';
import '../../../core/storage/key_value_store.dart';

@immutable
class OnboardingState {
  final int step; // 0=welcome, 1=prefs, 2=done
  final bool isComplete;
  final String? displayName;
  final bool emailTipsEnabled;
  final String? error;

  const OnboardingState({
    required this.step,
    required this.isComplete,
    this.displayName,
    required this.emailTipsEnabled,
    this.error,
  });

  factory OnboardingState.initial() =>
      const OnboardingState(step: 0, isComplete: false, emailTipsEnabled: true);

  OnboardingState copyWith({
    int? step,
    bool? isComplete,
    String? displayName,
    bool? emailTipsEnabled,
    String? error,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      isComplete: isComplete ?? this.isComplete,
      displayName: displayName ?? this.displayName,
      emailTipsEnabled: emailTipsEnabled ?? this.emailTipsEnabled,
      error: error,
    );
  }
}

final onboardingControllerProvider =
StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController();
});

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController() : super(OnboardingState.initial()) {
    _hydrate();
  }

  Future<void> _hydrate() async {
    try {
      final done =
          await KeyValueStore.readBool(AppKeys.onboardingDone) ?? false;
      final name = await KeyValueStore.readString(AppKeys.displayName);
      final tips =
          await KeyValueStore.readBool(AppKeys.emailTipsEnabled) ?? true;
      state = state.copyWith(
        isComplete: done,
        displayName: name,
        emailTipsEnabled: tips,
        error: '',
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void next() {
    if (state.step < 2) {
      state = state.copyWith(step: state.step + 1, error: '');
    }
  }

  void back() {
    if (state.step > 0) {
      state = state.copyWith(step: state.step - 1, error: '');
    }
  }

  void setDisplayName(String v) {
    state = state.copyWith(displayName: v, error: '');
  }

  void setEmailTips(bool enabled) {
    state = state.copyWith(emailTipsEnabled: enabled, error: '');
  }

  Future<void> complete() async {
    try {
      await KeyValueStore.writeBool(AppKeys.onboardingDone, true);
      if (state.displayName != null && state.displayName!.trim().isNotEmpty) {
        await KeyValueStore.writeString(
          AppKeys.displayName,
          state.displayName!.trim(),
        );
      }
      await KeyValueStore.writeBool(
          AppKeys.emailTipsEnabled, state.emailTipsEnabled);
      state = state.copyWith(isComplete: true, step: 2, error: '');
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> reset() async {
    try {
      await KeyValueStore.delete(AppKeys.onboardingDone);
      await KeyValueStore.delete(AppKeys.displayName);
      await KeyValueStore.delete(AppKeys.emailTipsEnabled);
      state = OnboardingState.initial();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
