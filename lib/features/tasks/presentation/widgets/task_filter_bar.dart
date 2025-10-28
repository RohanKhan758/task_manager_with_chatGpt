import 'package:flutter/material.dart';
import 'status_chip.dart';

class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar({super.key, required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  static const statuses = <String>['New', 'Progress', 'Completed', 'Canceled'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final s = statuses[i];
          return StatusChip(
            status: s,
            selected: s == value,
            onSelected: (v) => v ? onChanged(s) : null,
          );
        },
      ),
    );
  }
}
