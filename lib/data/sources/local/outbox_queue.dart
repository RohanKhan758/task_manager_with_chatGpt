import 'package:hive_flutter/hive_flutter.dart';

/// Basic offline outbox queue for unsynced actions.
/// Each item is a JSON map {type, payload, createdAt}.
class OutboxQueue {
  static const _boxName = 'outbox_queue';

  static Future<Box<Map>> _openBox() async {
    await Hive.initFlutter();
    return await Hive.openBox<Map>(_boxName);
  }

  /// Add a new pending action.
  static Future<void> enqueue(Map<String, dynamic> item) async {
    final box = await _openBox();
    await box.add({
      ...item,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  /// Return all pending actions.
  static Future<List<Map>> getAll() async {
    final box = await _openBox();
    return box.values.cast<Map>().toList();
  }

  /// Remove a specific item by index.
  static Future<void> removeAt(int index) async {
    final box = await _openBox();
    if (index >= 0 && index < box.length) {
      await box.deleteAt(index);
    }
  }

  /// Clear all queued actions.
  static Future<void> clear() async {
    final box = await _openBox();
    await box.clear();
  }
}
