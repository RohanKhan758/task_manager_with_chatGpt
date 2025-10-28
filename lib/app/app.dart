import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers.dart'; // our global Riverpod providers
import 'localization.dart'; // localization delegates

/// ------------------------------------------------------------
/// AppShell - Root widget for the entire Task Manager app.
/// ------------------------------------------------------------
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🔹 Read providers (theme, locale, router)
    final themeMode = ref.watch(themeModeProvider);
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);
    final locale = ref.watch(localeProvider);
    final supportedLocales = ref.watch(supportedLocalesProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,

      // -------------------
      // 🌐 Localization
      // -------------------
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: AppLocalization.baseDelegates,
      localeResolutionCallback: AppLocalization.resolve,

      // -------------------
      // 🎨 Themes
      // -------------------
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,

      // -------------------
      // 🧭 Routing
      // -------------------
      routerConfig: router,
    );
  }
}
