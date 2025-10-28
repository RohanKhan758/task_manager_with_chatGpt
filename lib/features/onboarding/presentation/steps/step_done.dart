import 'package:flutter/material.dart';

class StepDone extends StatelessWidget {
  const StepDone({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.celebration, size: 80, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text('All set!', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('You can change these settings anytime from Settings.'),
        ],
      ),
    );
  }
}
