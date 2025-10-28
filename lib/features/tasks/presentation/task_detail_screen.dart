import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/task_detail_controller.dart';
import '../../../data/models/task.dart';

class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({super.key, this.initial});
  final Task? initial;

  static const statuses = <String>['New', 'Progress', 'Completed', 'Canceled'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.watch(taskDetailControllerProvider(initial).notifier);
    final state = ref.watch(taskDetailControllerProvider(initial));
    final t = state.task;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task details'),
        actions: [
          if (t != null)
            IconButton(
              tooltip: 'Delete',
              onPressed: state.isWorking
                  ? null
                  : () async {
                final ok = await ctrl.delete();
                if (context.mounted && ok) Navigator.of(context).pop(true);
              },
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: t == null
          ? const Center(child: Text('Task removed'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(t.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            if (t.description != null && t.description!.isNotEmpty)
              Text(t.description!),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                for (final s in statuses)
                  ChoiceChip(
                    label: Text(s),
                    selected: t.status == s,
                    onSelected: state.isWorking
                        ? null
                        : (v) => v ? ctrl.updateStatus(s) : null,
                  ),
              ],
            ),
            const SizedBox(height: 24),
            if (state.error != null && state.error!.isNotEmpty)
              Text(
                state.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            if (state.isWorking) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
