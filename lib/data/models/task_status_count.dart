import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_status_count.freezed.dart';
part 'task_status_count.g.dart';

/// Represents the response from `/taskStatusCount`
/// Example:
/// [ { "_id": "New", "sum": 4 }, { "_id": "Completed", "sum": 7 } ]
@freezed
class TaskStatusCount with _$TaskStatusCount {
  const factory TaskStatusCount({
    @JsonKey(name: '_id') required String id,
    required int sum,
  }) = _TaskStatusCount;

  factory TaskStatusCount.fromJson(Map<String, dynamic> json) =>
      _$TaskStatusCountFromJson(json);
}
