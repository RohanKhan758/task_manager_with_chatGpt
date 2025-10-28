import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/task_status_count.dart';
import '../../../data/repositories/task_repository.dart';

/// Local repo provider (kept here so Dashboard is self-contained)
final _repoProvider = Provider<TaskRepository>((ref) => TaskRepository());

/// Dashboard state: status counts + loading/error
@immutable
class DashboardState {
  final bool isLoading;
  final bool isRefreshing;
  final List<TaskStatusCount> counts;
  final String? error;

  const DashboardState({
    required this.isLoading,
    required this.isRefreshing,
    required this.counts,
    this.error,
  });

  factory DashboardState.initial() => const DashboardState(
    isLoading: true,
    isRefreshing: false,
    counts: [],
    error: null,
  );

  DashboardState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    List<TaskStatusCount>? counts,
    String? error, // set '' to clear
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      counts: counts ?? this.counts,
      error: error,
    );
  }

  int countFor(String status) {
    return counts.firstWhere(
          (e) => e.id == status,
      orElse: () => const TaskStatusCount(id: 'none', sum: 0),
    ).sum;
  }

  Map<String, int> asMap() {
    final m = <String, int>{};
    for (final c in counts) {
      m[c.id] = c.sum;
    }
    return m;
  }
}

final dashboardControllerProvider =
StateNotifierProvider<DashboardController, DashboardState>((ref) {
  final repo = ref.watch(_repoProvider);
  return DashboardController(repo)..load();
});

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController(this._repo) : super(DashboardState.initial());

  final TaskRepository _repo;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: '');
    try {
      final data = await _repo.statusCounts();
      state = state.copyWith(isLoading: false, counts: data, error: '');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, error: '');
    try {
      final data = await _repo.statusCounts();
      state = state.copyWith(isRefreshing: false, counts: data, error: '');
    } catch (e) {
      state = state.copyWith(isRefreshing: false, error: e.toString());
    }
  }
}
