import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/task_wizard_controller.dart';
import 'widgets/task_stepper.dart';

class TaskCreateWizard extends ConsumerWidget {
  const TaskCreateWizard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskWizardControllerProvider);
    final ctrl = ref.read(taskWizardControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Create task')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TaskStepper(current: state.step),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _WizardBody(),
                  ),
                  if (state.error != null && state.error!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      state.error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (state.step != TaskWizardStep.title)
                        TextButton.icon(
                          onPressed: state.isSubmitting ? null : ctrl.back,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                        ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: state.isSubmitting
                            ? null
                            : () async {
                          if (state.step == TaskWizardStep.review) {
                            final created = await ctrl.submit();
                            if (created != null && context.mounted) {
                              Navigator.of(context).pop(created);
                            }
                          } else {
                            ctrl.next();
                          }
                        },
                        icon: state.step == TaskWizardStep.review
                            ? const Icon(Icons.check_circle_outline)
                            : const Icon(Icons.arrow_forward),
                        label: Text(
                          state.step == TaskWizardStep.review ? 'Create' : 'Next',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WizardBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskWizardControllerProvider);
    final ctrl = ref.read(taskWizardControllerProvider.notifier);

    switch (state.step) {
      case TaskWizardStep.title:
        return _TitleStep(
          value: state.title,
          onChanged: ctrl.setTitle,
        );
      case TaskWizardStep.description:
        return _DescriptionStep(
          value: state.description,
          onChanged: ctrl.setDescription,
        );
      case TaskWizardStep.status:
        return _StatusStep(
          value: state.status,
          onChanged: ctrl.setStatus,
        );
      case TaskWizardStep.review:
        return _ReviewStep();
      case TaskWizardStep.done:
        return const Center(child: Text('Done'));
    }
  }
}

class _TitleStep extends StatelessWidget {
  const _TitleStep({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      autofocus: true,
      decoration: const InputDecoration(
        labelText: 'Title',
        hintText: 'What do you want to get done?',
        prefixIcon: Icon(Icons.title),
      ),
      onChanged: onChanged,
    );
  }
}

class _DescriptionStep extends StatelessWidget {
  const _DescriptionStep({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      maxLines: 6,
      decoration: const InputDecoration(
        labelText: 'Description (optional)',
        hintText: 'Add more details…',
        prefixIcon: Icon(Icons.notes_outlined),
      ),
      onChanged: onChanged,
    );
  }
}

class _StatusStep extends StatelessWidget {
  const _StatusStep({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  static const statuses = <String>['New', 'Progress', 'Completed', 'Canceled'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        for (final s in statuses)
          ChoiceChip(
            label: Text(s),
            selected: value == s,
            onSelected: (v) => v ? onChanged(s) : null,
          )
      ],
    );
  }
}

class _ReviewStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskWizardControllerProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyLarge!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row('Title', state.title.isEmpty ? '—' : state.title),
              _row('Description',
                  state.description.isEmpty ? '—' : state.description),
              _row('Status', state.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600))),
          const SizedBox(width: 8),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}
