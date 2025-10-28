/// Centralized storage keys for SharedPreferences and SecureStorage.
/// Keeping them here ensures no typos and easy reuse across the app.
class AppKeys {
  AppKeys._();

  // -------------------
  // Secure Storage Keys
  // -------------------
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';

  // -------------------
  // Shared Preferences Keys
  // -------------------
  static const String themeMode = 'theme_mode'; // light/dark/system
  static const String locale = 'locale'; // 'en' or 'bn'
  static const String onboardingShown = 'onboarding_shown';
  static const String lastSyncTime = 'last_sync_time';
  static const String cachedDashboardData = 'cached_dashboard_data';

  // Add to AppKeys
  static const onboardingDone = 'onboarding_done';
  static const displayName = 'display_name';
  static const emailTipsEnabled = 'email_tips_enabled';
}
