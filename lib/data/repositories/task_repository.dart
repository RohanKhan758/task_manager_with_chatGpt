import '../../core/errors/error_mapper.dart';
import '../../core/errors/failures.dart';

import '../models/task.dart';
import '../models/task_status_count.dart';
import '../sources/remote/task_api.dart';

/// Coordinates task operations. (Room for local cache/outbox later.)
class TaskRepository {
  TaskRepository({TaskApi? api}) : _api = api ?? TaskApi();
  final TaskApi _api;

  Future<Task> create({
    required String title,
    String? description,
    String status = 'New',
  }) async {
    try {
      return await _api.createTask(
        title: title,
        description: description,
        status: status,
      );
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  Future<List<Task>> listByStatus(String status) async {
    try {
      return await _api.listByStatus(status);
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  Future<Task> updateStatus({
    required String id,
    required String status,
  }) async {
    try {
      return await _api.updateStatus(id: id, status: status);
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  Future<bool> delete(String id) async {
    try {
      return await _api.deleteTask(id);
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  Future<List<TaskStatusCount>> statusCounts() async {
    try {
      return await _api.taskStatusCount();
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }
}
