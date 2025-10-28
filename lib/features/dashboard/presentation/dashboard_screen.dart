import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../tasks/providers/task_list_controller.dart'; // to set filter before navigating
import '../providers/dashboard_controller.dart';
import 'widgets/status_counter_chips.dart';
import 'widgets/status_chart.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const statuses = ['New', 'Progress', 'Completed', 'Canceled'];

  void _openTasks(BuildContext context, WidgetRef ref, String status) {
    // Set the task list filter, then navigate to the list
    ref.read(taskStatusFilterProvider.notifier).state = status;
    context.go('/tasks');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardControllerProvider);
    final ctrl = ref.read(dashboardControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: state.isLoading ? null : ctrl.refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: ctrl.refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (state.isLoading) const LinearProgressIndicator(),

            const SizedBox(height: 12),

            // Status chips with counts
            StatusCounterChips(
              counts: {
                for (final s in statuses) s: state.countFor(s),
              },
              onTap: (s) => _openTasks(context, ref, s),
            ),

            const SizedBox(height: 16),

            // Simple bar chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StatusChart(
                  data: {
                    for (final s in statuses) s: state.countFor(s),
                  },
                  title: 'Task status overview',
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Error (if any)
            if (state.error != null && state.error!.isNotEmpty)
              Text(
                state.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tasks/create'),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }
}
