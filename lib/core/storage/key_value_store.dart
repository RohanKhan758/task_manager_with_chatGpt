import 'package:shared_preferences/shared_preferences.dart';

/// Tiny static wrapper around SharedPreferences for simple key/value storage.
/// Non-sensitive only (use SecureStorage for secrets).
class KeyValueStore {
  // ---- Reads ----
  static Future<bool?> readBool(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(key);
  }

  static Future<String?> readString(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  static Future<int?> readInt(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }

  static Future<double?> readDouble(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getDouble(key);
  }

  static Future<List<String>?> readStringList(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(key);
  }

  // ---- Writes ----
  static Future<void> writeBool(String key, bool value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(key, value);
  }

  static Future<void> writeString(String key, String value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(key, value);
  }

  static Future<void> writeInt(String key, int value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(key, value);
  }

  static Future<void> writeDouble(String key, double value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setDouble(key, value);
  }

  static Future<void> writeStringList(String key, List<String> value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(key, value);
  }

  // ---- Remove / Clear ----
  static Future<void> delete(String key) async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(key);
  }

  static Future<void> clearAll() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
  }
}
