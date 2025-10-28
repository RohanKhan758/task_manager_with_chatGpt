import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

/// A task item from your API.
/// Example:
/// {
///   "_id": "65b4a19d279fb0f60f610bb2",
///   "title": "Write report",
///   "description": "Complete the science fair report",
///   "status": "New",
///   "email": "user@example.com",
///   "createdDate": "2024-01-27T06:24:25.316Z"
/// }
@freezed
class Task with _$Task {
  const factory Task({
    @JsonKey(name: '_id') required String id,
    required String title,
    String? description,

    /// Backend uses plain strings like "New", "Completed", etc.
    required String status,

    /// Owner email as returned by the API
    String? email,

    /// ISO date string from server -> DateTime here
    @JsonKey(name: 'createdDate') DateTime? createdDate,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
