import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../onboarding/providers/onboarding_controller.dart';
import '../providers/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsControllerProvider);
    final ctrl = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Appearance'),
          RadioListTile<ThemeMode>(
            title: const Text('System'),
            value: ThemeMode.system,
            groupValue: state.themeMode,
            onChanged: (v) => v != null ? ctrl.setTheme(v) : null,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: state.themeMode,
            onChanged: (v) => v != null ? ctrl.setTheme(v) : null,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: state.themeMode,
            onChanged: (v) => v != null ? ctrl.setTheme(v) : null,
          ),
          const Divider(height: 24),

          const _SectionHeader('Language'),
          ListTile(
            title: const Text('English'),
            trailing: state.locale.languageCode == 'en' ? const Icon(Icons.check) : null,
            onTap: () => ctrl.setLocale(const Locale('en')),
          ),
          ListTile(
            title: const Text('বাংলা'),
            trailing: state.locale.languageCode == 'bn' ? const Icon(Icons.check) : null,
            onTap: () => ctrl.setLocale(const Locale('bn')),
          ),
          const Divider(height: 24),

          const _SectionHeader('Profile'),
          ListTile(
            title: const Text('Display name'),
            subtitle: Text(state.displayName ?? 'Not set'),
            trailing: const Icon(Icons.edit_outlined),
            onTap: () async {
              final name = await _editNameDialog(context, state.displayName);
              if (name != null) await ctrl.setDisplayName(name);
            },
          ),
          SwitchListTile(
            title: const Text('Receive tips by email'),
            value: state.emailTipsEnabled,
            onChanged: (v) => ctrl.setEmailTips(v),
          ),
          const Divider(height: 24),

          const _SectionHeader('Onboarding'),
          ListTile(
            title: const Text('Reset onboarding'),
            trailing: const Icon(Icons.restart_alt),
            onTap: () async {
              await ref.read(onboardingControllerProvider.notifier).reset();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Onboarding has been reset')),
                );
              }
            },
          ),

          if (state.error != null && state.error!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(state.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<String?> _editNameDialog(BuildContext context, String? current) async {
    final c = TextEditingController(text: current ?? '');
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Display name'),
        content: TextField(
          controller: c,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter your display name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, c.text.trim()), child: const Text('Save')),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
