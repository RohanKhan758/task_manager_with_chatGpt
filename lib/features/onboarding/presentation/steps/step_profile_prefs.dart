import 'package:flutter/material.dart';

class StepProfilePrefs extends StatefulWidget {
  const StepProfilePrefs({
    super.key,
    required this.initialName,
    required this.initialEmailTips,
    required this.onNameChanged,
    required this.onEmailTipsChanged,
  });

  final String initialName;
  final bool initialEmailTips;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<bool> onEmailTipsChanged;

  @override
  State<StepProfilePrefs> createState() => _StepProfilePrefsState();
}

class _StepProfilePrefsState extends State<StepProfilePrefs> {
  late final TextEditingController _nameC;
  bool _tips = true;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(text: widget.initialName);
    _tips = widget.initialEmailTips;
  }

  @override
  void dispose() {
    _nameC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      children: [
        const SizedBox(height: 12),
        Text('Personalize', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Add an optional display name and choose if you want helpful tips by email.',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: _nameC,
          decoration: const InputDecoration(
            labelText: 'Display name (optional)',
            prefixIcon: Icon(Icons.badge_outlined),
          ),
          onChanged: widget.onNameChanged,
        ),
        const SizedBox(height: 12),

        SwitchListTile(
          title: const Text('Receive productivity tips by email'),
          value: _tips,
          onChanged: (v) {
            setState(() => _tips = v);
            widget.onEmailTipsChanged(v);
          },
        ),
      ],
    );
  }
}
