import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/task.dart';
import '../../../data/repositories/task_repository.dart';

/// ------------------------------------------------------------------
/// Providers
/// ------------------------------------------------------------------

/// Expose the repository (can be overridden in tests)
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

/// Current status filter (defaults to "New")
final taskStatusFilterProvider = StateProvider<String>((ref) => 'New');

/// Task list state for the active status filter
final taskListControllerProvider =
StateNotifierProvider<TaskListController, TaskListState>((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  final status = ref.watch(taskStatusFilterProvider);
  return TaskListController(repo, initialStatus: status);
});

/// ------------------------------------------------------------------
/// State
/// ------------------------------------------------------------------

@immutable
class TaskListState {
  final String status;           // e.g. 'New' | 'Progress' | 'Completed' | 'Canceled'
  final bool isLoading;
  final bool isRefreshing;
  final List<Task> items;
  final String? error;

  const TaskListState({
    required this.status,
    required this.isLoading,
    required this.isRefreshing,
    required this.items,
    this.error,
  });

  factory TaskListState.initial(String status) => TaskListState(
    status: status,
    isLoading: true,
    isRefreshing: false,
    items: const [],
    error: null,
  );

  TaskListState copyWith({
    String? status,
    bool? isLoading,
    bool? isRefreshing,
    List<Task>? items,
    String? error, // pass '' to clear
  }) {
    return TaskListState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      items: items ?? this.items,
      error: error,
    );
  }
}

/// ------------------------------------------------------------------
/// Controller
/// ------------------------------------------------------------------

class TaskListController extends StateNotifier<TaskListState> {
  TaskListController(this._repo, {required String initialStatus})
      : super(TaskListState.initial(initialStatus)) {
    load(); // auto-load for initial status
  }

  final TaskRepository _repo;

  /// Load tasks (initially or after filter change)
  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: '');
    try {
      final list = await _repo.listByStatus(state.status);
      state = state.copyWith(isLoading: false, items: list, error: '');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Pull-to-refresh style reload
  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, error: '');
    try {
      final list = await _repo.listByStatus(state.status);
      state = state.copyWith(isRefreshing: false, items: list, error: '');
    } catch (e) {
      state = state.copyWith(isRefreshing: false, error: e.toString());
    }
  }

  /// Change status filter (e.g., New → Completed) and reload
  Future<void> setStatus(String status) async {
    if (status == state.status) return;
    state = TaskListState.initial(status);
    await load();
  }

  /// Update a task locally after status change or edit
  void upsertLocal(Task task) {
    final idx = state.items.indexWhere((t) => t.id == task.id);
    final list = [...state.items];
    if (idx >= 0) {
      list[idx] = task;
    } else {
      list.insert(0, task);
    }
    state = state.copyWith(items: list);
  }

  /// Remove a task locally (after delete)
  void removeLocal(String id) {
    state = state.copyWith(items: state.items.where((t) => t.id != id).toList());
  }
}
