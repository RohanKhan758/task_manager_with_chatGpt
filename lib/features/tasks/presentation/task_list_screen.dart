import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/task_list_controller.dart';
import '../../../data/models/task.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  static const statuses = <String>['New', 'Progress', 'Completed', 'Canceled'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskListControllerProvider);
    final ctrl = ref.read(taskListControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            tooltip: 'Create task',
            onPressed: () => context.push('/tasks/create'),
            icon: const Icon(Icons.add_circle_outline),
          )
        ],
      ),
      body: Column(
        children: [
          // ---- Status filter chips ----
          SizedBox(
            height: 52,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                final s = statuses[i];
                final selected = s == state.status;
                return ChoiceChip(
                  label: Text(s),
                  selected: selected,
                  onSelected: (v) => v ? ctrl.setStatus(s) : null,
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: statuses.length,
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: ctrl.refresh,
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.error != null && state.error!.isNotEmpty
                  ? _ErrorView(
                message: state.error!,
                onRetry: ctrl.load,
              )
                  : state.items.isEmpty
                  ? const _EmptyView()
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                itemCount: state.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) =>
                    _TaskTile(task: state.items[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends ConsumerWidget {
  const _TaskTile({required this.task});
  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  task.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(task.status),
            ),
          ],
        ),
        onTap: () => context.push('/tasks/${task.id}', extra: task),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 56, color: cs.outline),
            const SizedBox(height: 12),
            const Text('No tasks yet'),
            const SizedBox(height: 6),
            Text(
              'Try changing the status filter or create a new task.',
              style: TextStyle(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56, color: cs.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            )
          ],
        ),
      ),
    );
  }
}
