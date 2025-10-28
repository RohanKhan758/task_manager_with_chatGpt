import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/task.dart';
import '../../../data/repositories/task_repository.dart';
import 'task_list_controller.dart';

/// Detail state for a single task
@immutable
class TaskDetailState {
  final Task? task;
  final bool isLoading;
  final bool isWorking; // update/delete in-flight
  final String? error;

  const TaskDetailState({
    required this.task,
    required this.isLoading,
    required this.isWorking,
    this.error,
  });

  factory TaskDetailState.initial(Task? initial) => TaskDetailState(
    task: initial,
    isLoading: false,
    isWorking: false,
    error: null,
  );

  TaskDetailState copyWith({
    Task? task,
    bool? isLoading,
    bool? isWorking,
    String? error, // set '' to clear
  }) {
    return TaskDetailState(
      task: task ?? this.task,
      isLoading: isLoading ?? this.isLoading,
      isWorking: isWorking ?? this.isWorking,
      error: error,
    );
  }
}

/// Provider that needs a Task as parameter (or at least an ID and snapshot)
final taskDetailControllerProvider = StateNotifierProvider.family<
    TaskDetailController, TaskDetailState, Task?>((ref, initialTask) {
  final repo = ref.watch(taskRepositoryProvider);
  final listCtrl = ref.read(taskListControllerProvider.notifier);
  return TaskDetailController(repo, listCtrl, initial: initialTask);
});

class TaskDetailController extends StateNotifier<TaskDetailState> {
  TaskDetailController(this._repo, this._listCtrl, {Task? initial})
      : super(TaskDetailState.initial(initial));

  final TaskRepository _repo;
  final TaskListController _listCtrl;

  /// Update the task status (e.g., New → Completed)
  Future<Task?> updateStatus(String status) async {
    final t = state.task;
    if (t == null) return null;

    state = state.copyWith(isWorking: true, error: '');
    try {
      final updated = await _repo.updateStatus(id: t.id, status: status);
      // Push the change into the list controller too
      _listCtrl.upsertLocal(updated);
      state = state.copyWith(isWorking: false, task: updated, error: '');
      return updated;
    } catch (e) {
      state = state.copyWith(isWorking: false, error: e.toString());
      return null;
    }
  }

  /// Delete the task
  Future<bool> delete() async {
    final t = state.task;
    if (t == null) return false;

    state = state.copyWith(isWorking: true, error: '');
    try {
      final ok = await _repo.delete(t.id);
      if (ok) {
        _listCtrl.removeLocal(t.id);
        state = state.copyWith(isWorking: false, task: null, error: '');
        return true;
      }
      state = state.copyWith(isWorking: false, error: 'Delete failed');
      return false;
    } catch (e) {
      state = state.copyWith(isWorking: false, error: e.toString());
      return false;
    }
  }

  /// If a newer Task instance arrives (e.g., from list refresh), update local
  void setTask(Task task) {
    state = state.copyWith(task: task);
  }
}
