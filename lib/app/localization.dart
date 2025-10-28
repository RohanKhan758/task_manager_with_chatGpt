import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// We will wrap the app with EasyLocalization later.
// import 'package:easy_localization/easy_localization.dart';

/// Central localization config used across the app.
/// For now, we expose the delegates and supported locales
/// in a way that compiles immediately without EasyLocalization.
/// Later, when we wrap the app with EasyLocalization, we will
/// switch to using context.localizationDelegates, etc.
class AppLocalization {
  AppLocalization._();

  /// Language assets path (already declared in pubspec under "assets: - l10n/")
  static const String translationsPath = 'l10n';

  /// Fallback locale if device language not supported
  static const Locale fallbackLocale = Locale('en');

  /// Locales we support now; feel free to add more later.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'), // English
    Locale('bn'), // Bangla
  ];

  /// Minimal delegates so Material/Cupertino widgets localize.
  /// (When we enable EasyLocalization wrapper, we will swap to:
  ///   context.localizationDelegates
  ///   context.supportedLocales
  ///   context.locale
  /// )
  static const List<LocalizationsDelegate<dynamic>> baseDelegates = <LocalizationsDelegate<dynamic>>[
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// Optional resolution callback (keeps locale stable to what we support).
  static Locale? resolve(Locale? locale, Iterable<Locale> supported) {
    if (locale == null) return fallbackLocale;
    for (final l in supported) {
      if (l.languageCode == locale.languageCode) return l;
    }
    return fallbackLocale;
  }
}
