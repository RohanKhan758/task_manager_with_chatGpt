import 'package:flutter/material.dart';

class StatusCounterChips extends StatelessWidget {
  const StatusCounterChips({
    super.key,
    required this.counts,
    required this.onTap,
  });

  /// Map like { 'New': 3, 'Progress': 2, 'Completed': 7, 'Canceled': 1 }
  final Map<String, int> counts;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final entries = counts.entries.toList();

    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final e = entries[i];
          return InputChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(e.key),
                const SizedBox(width: 8),
                _Bubble(text: '${e.value}'),
              ],
            ),
            onPressed: () => onTap(e.key),
          );
        },
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
