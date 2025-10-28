import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_keys.dart';
import '../../../core/storage/key_value_store.dart';
import '../../../app/providers.dart'; // themeModeProvider, localeProvider

@immutable
class SettingsState {
  final ThemeMode themeMode;
  final Locale locale;
  final bool emailTipsEnabled;
  final String? displayName;
  final String? error;

  const SettingsState({
    required this.themeMode,
    required this.locale,
    required this.emailTipsEnabled,
    this.displayName,
    this.error,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? emailTipsEnabled,
    String? displayName,
    String? error,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      emailTipsEnabled: emailTipsEnabled ?? this.emailTipsEnabled,
      displayName: displayName ?? this.displayName,
      error: error,
    );
  }

  factory SettingsState.initial() =>
      const SettingsState(themeMode: ThemeMode.system, locale: Locale('en'), emailTipsEnabled: true);
}

final settingsControllerProvider =
StateNotifierProvider<SettingsController, SettingsState>((ref) {
  final theme = ref.read(themeModeProvider);
  final locale = ref.read(localeProvider);
  return SettingsController(ref, theme, locale);
});

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController(this._ref, ThemeMode initialTheme, Locale initialLocale)
      : super(SettingsState.initial().copyWith(themeMode: initialTheme, locale: initialLocale)) {
    _hydrate();
  }

  final Ref _ref;

  Future<void> _hydrate() async {
    try {
      final tips = await KeyValueStore.readBool(AppKeys.emailTipsEnabled) ?? true;
      final name = await KeyValueStore.readString(AppKeys.displayName);
      state = state.copyWith(emailTipsEnabled: tips, displayName: name, error: '');
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void setTheme(ThemeMode mode) {
    state = state.copyWith(themeMode: mode, error: '');
    _ref.read(themeModeProvider.notifier).state = mode;
  }

  void setLocale(Locale locale) {
    state = state.copyWith(locale: locale, error: '');
    _ref.read(localeProvider.notifier).state = locale;
  }

  Future<void> setEmailTips(bool enabled) async {
    try {
      await KeyValueStore.writeBool(AppKeys.emailTipsEnabled, enabled);
      state = state.copyWith(emailTipsEnabled: enabled, error: '');
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> setDisplayName(String? name) async {
    try {
      if (name == null || name.trim().isEmpty) {
        await KeyValueStore.delete(AppKeys.displayName);
        state = state.copyWith(displayName: null, error: '');
      } else {
        await KeyValueStore.writeString(AppKeys.displayName, name.trim());
        state = state.copyWith(displayName: name.trim(), error: '');
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
