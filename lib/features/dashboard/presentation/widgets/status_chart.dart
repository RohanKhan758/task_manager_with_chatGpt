import 'package:flutter/material.dart';

/// Very small, dependency-free bar chart for status counts.
/// Pass data like: { 'New': 3, 'Progress': 2, 'Completed': 7, 'Canceled': 1 }
class StatusChart extends StatelessWidget {
  const StatusChart({
    super.key,
    required this.data,
    this.title,
  });

  final Map<String, int> data;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    final max = (entries.map((e) => e.value).fold<int>(0, (a, b) => a > b ? a : b)).toDouble();
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title!, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
        ],
        ...entries.map((e) {
          final pct = max == 0 ? 0.0 : (e.value / max);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(width: 100, child: Text(e.key)),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final w = constraints.maxWidth * pct;
                        return Stack(
                          children: [
                            Container(
                              height: 16,
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerHighest,
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOut,
                              height: 16,
                              width: w,
                              decoration: BoxDecoration(
                                color: cs.primary.withOpacity(0.85),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(width: 32, child: Text('${e.value}', textAlign: TextAlign.right)),
              ],
            ),
          );
        }),
      ],
    );
  }
}
