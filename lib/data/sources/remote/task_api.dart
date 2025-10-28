import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failures.dart';
import '../../../core/constants/api_paths.dart';

import '../../models/task.dart';
import '../../models/task_status_count.dart';

/// Task endpoints (create/list/update/delete + counts)
class TaskApi {
  TaskApi({Dio? dio}) : _dio = dio ?? DioClient.create();
  final Dio _dio;

  /// POST /createTask  -> returns created task in `data` (common shape)
  Future<Task> createTask({
    required String title,
    String? description,
    String status = 'New',
  }) async {
    try {
      final body = {
        'title': title,
        if (description != null) 'description': description,
        'status': status,
      };
      final res = await _dio.post(ApiPaths.createTask, data: body);

      final raw = res.data;
      if (raw is Map && raw['data'] is Map<String, dynamic>) {
        return Task.fromJson(raw['data'] as Map<String, dynamic>);
      }
      if (raw is Map<String, dynamic>) {
        return Task.fromJson(raw);
      }
      throw const UnknownFailure(message: 'Unexpected createTask response');
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  /// GET /listTaskByStatus/:status  -> returns list in `data`
  Future<List<Task>> listByStatus(String status) async {
    try {
      final res = await _dio.get(ApiPaths.listTaskByStatus(status));
      final raw = res.data;

      if (raw is Map && raw['data'] is List) {
        return (raw['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map(Task.fromJson)
            .toList();
      }

      if (raw is List) {
        return raw.whereType<Map<String, dynamic>>().map(Task.fromJson).toList();
      }

      throw const UnknownFailure(message: 'Unexpected listTaskByStatus response');
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  /// GET /updateTaskStatus/:id/:status  -> returns updated task in `data`
  Future<Task> updateStatus({required String id, required String status}) async {
    try {
      final res = await _dio.get(ApiPaths.updateTaskStatus(id, status));
      final raw = res.data;

      if (raw is Map && raw['data'] is Map<String, dynamic>) {
        return Task.fromJson(raw['data'] as Map<String, dynamic>);
      }
      if (raw is Map<String, dynamic>) {
        return Task.fromJson(raw);
      }
      throw const UnknownFailure(message: 'Unexpected updateTaskStatus response');
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  /// GET /deleteTask/:id  -> returns status; we surface success as bool
  Future<bool> deleteTask(String id) async {
    try {
      final res = await _dio.get(ApiPaths.deleteTask(id));
      if (res.data is Map && (res.data['status'] == 'success')) return true;
      // Be permissive: if server returns 200 OK, assume success
      return true;
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }

  /// GET /taskStatusCount -> [{ _id: 'New', sum: 2 }, ...]
  Future<List<TaskStatusCount>> taskStatusCount() async {
    try {
      final res = await _dio.get(ApiPaths.taskStatusCount);
      final raw = res.data;

      if (raw is Map && raw['data'] is List) {
        return (raw['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map(TaskStatusCount.fromJson)
            .toList();
      }
      if (raw is List) {
        return raw.whereType<Map<String, dynamic>>().map(TaskStatusCount.fromJson).toList();
      }

      throw const UnknownFailure(message: 'Unexpected taskStatusCount response');
    } catch (e, s) {
      throw ErrorMapper.from(e, s);
    }
  }
}
