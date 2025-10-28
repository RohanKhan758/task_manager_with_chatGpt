import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/task.dart';
import '../../../data/repositories/task_repository.dart';
import 'task_list_controller.dart';

/// Steps for the multi-step wizard UI
enum TaskWizardStep { title, description, status, review, done }

@immutable
class TaskWizardState {
  final TaskWizardStep step;
  final String title;
  final String description;
  final String status; // New | Progress | Completed | Canceled (default New)
  final bool isSubmitting;
  final Task? created;
  final String? error;

  const TaskWizardState({
    required this.step,
    required this.title,
    required this.description,
    required this.status,
    required this.isSubmitting,
    this.created,
    this.error,
  });

  factory TaskWizardState.initial() => const TaskWizardState(
    step: TaskWizardStep.title,
    title: '',
    description: '',
    status: 'New',
    isSubmitting: false,
    created: null,
    error: null,
  );

  TaskWizardState copyWith({
    TaskWizardStep? step,
    String? title,
    String? description,
    String? status,
    bool? isSubmitting,
    Task? created,
    String? error, // set '' to clear
  }) {
    return TaskWizardState(
      step: step ?? this.step,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      created: created ?? this.created,
      error: error,
    );
  }
}

/// Repository provider reused from list controller
final _repoProvider = taskRepositoryProvider;

/// Top-level provider for the wizard state/controller
final taskWizardControllerProvider =
StateNotifierProvider<TaskWizardController, TaskWizardState>((ref) {
  final repo = ref.watch(_repoProvider);
  final listCtrl = ref.read(taskListControllerProvider.notifier);
  return TaskWizardController(repo, listCtrl);
});

class TaskWizardController extends StateNotifier<TaskWizardState> {
  TaskWizardController(this._repo, this._listCtrl)
      : super(TaskWizardState.initial());

  final TaskRepository _repo;
  final TaskListController _listCtrl;

  // ----- Step navigation -----
  void setTitle(String v) => state = state.copyWith(title: v, error: '');
  void setDescription(String v) =>
      state = state.copyWith(description: v, error: '');
  void setStatus(String v) => state = state.copyWith(status: v, error: '');

  void next() {
    switch (state.step) {
      case TaskWizardStep.title:
        state = state.copyWith(step: TaskWizardStep.description);
        break;
      case TaskWizardStep.description:
        state = state.copyWith(step: TaskWizardStep.status);
        break;
      case TaskWizardStep.status:
        state = state.copyWith(step: TaskWizardStep.review);
        break;
      case TaskWizardStep.review:
      // handled by submit()
        break;
      case TaskWizardStep.done:
        break;
    }
  }

  void back() {
    switch (state.step) {
      case TaskWizardStep.title:
        break;
      case TaskWizardStep.description:
        state = state.copyWith(step: TaskWizardStep.title);
        break;
      case TaskWizardStep.status:
        state = state.copyWith(step: TaskWizardStep.description);
        break;
      case TaskWizardStep.review:
        state = state.copyWith(step: TaskWizardStep.status);
        break;
      case TaskWizardStep.done:
        state = state.copyWith(step: TaskWizardStep.review);
        break;
    }
  }

  /// Submit -> create the task via API
  Future<Task?> submit() async {
    if (state.title.trim().isEmpty) {
      state = state.copyWith(error: 'Title is required');
      return null;
    }
    state = state.copyWith(isSubmitting: true, error: '');
    try {
      final t = await _repo.create(
        title: state.title.trim(),
        description:
        state.description.trim().isEmpty ? null : state.description.trim(),
        status: state.status,
      );
      // Push into list cache so UI updates immediately
      _listCtrl.upsertLocal(t);
      state = state.copyWith(
        isSubmitting: false,
        created: t,
        step: TaskWizardStep.done,
        error: '',
      );
      return t;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return null;
    }
  }

  void reset() => state = TaskWizardState.initial();
}
