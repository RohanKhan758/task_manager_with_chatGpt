// exports must be before any declarations
export 'router.dart' show routerProvider;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'env.dart';
import '../app/theme.dart';

// -------------------------
// Environment & constants
// -------------------------
final baseUrlProvider = Provider<String>((ref) => AppEnv.baseUrl);
final envSummaryProvider = Provider<String>((ref) => AppEnv.summary());

// -------------------------
// Theme & Localization
// -------------------------
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
final lightThemeProvider = Provider<ThemeData>((ref) => AppTheme.light());
final darkThemeProvider  = Provider<ThemeData>((ref)  => AppTheme.dark());

final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));
final supportedLocalesProvider = Provider<List<Locale>>((ref) => const [
  Locale('en'),
  Locale('bn'),
]);

// Router is re-exported above from router.dart
