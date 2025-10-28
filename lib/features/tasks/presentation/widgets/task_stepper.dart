import 'package:flutter/material.dart';
import '../../providers/task_wizard_controller.dart';

class TaskStepper extends StatelessWidget {
  const TaskStepper({super.key, required this.current});
  final TaskWizardStep current;

  @override
  Widget build(BuildContext context) {
    final steps = [
      _Step('Title', Icons.title, TaskWizardStep.title),
      _Step('Description', Icons.notes_outlined, TaskWizardStep.description),
      _Step('Status', Icons.flag_outlined, TaskWizardStep.status),
      _Step('Review', Icons.fact_check_outlined, TaskWizardStep.review),
    ];
    return Row(
      children: steps.map((s) {
        final active = s.step == current;
        return Expanded(
          child: Column(
            children: [
              Icon(s.icon, color: active ? Theme.of(context).colorScheme.primary : null),
              const SizedBox(height: 4),
              Text(
                s.label,
                style: TextStyle(
                  fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _Step {
  final String label;
  final IconData icon;
  final TaskWizardStep step;
  _Step(this.label, this.icon, this.step);
}
