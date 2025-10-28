import 'package:hive_flutter/hive_flutter.dart';

/// Simple Hive bootstrap for offline cache and settings.
/// Call `LocalDB.init()` before runApp() if you plan to use local storage.
class LocalDB {
  static bool _initialized = false;

  /// Initialize Hive and register adapters.
  static Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();

    // TODO: register adapters if you add model caching later
    // Hive.registerAdapter(TaskAdapter());

    _initialized = true;
  }

  /// Open a box safely.
  static Future<Box<T>> openBox<T>(String name) async {
    await init();
    return await Hive.openBox<T>(name);
  }

  /// Clear all boxes — for logout or debug reset.
  static Future<void> clearAll() async {
    for (final name in Hive.boxNames) {
      final box = Hive.box(name);
      await box.clear();
    }
  }
}
