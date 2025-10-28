import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/validators.dart';
import 'package:task_manager/features/auth/providers/auth_controller.dart';
import 'package:task_manager/features/auth/providers/profile_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstC = TextEditingController();
  final _lastC = TextEditingController();
  final _mobileC = TextEditingController();
  final _passwordC = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load profile on open
    Future.microtask(() async {
      final p = await ref.read(profileControllerProvider.notifier).refresh();
      if (p != null) {
        _firstC.text = p.firstName ?? '';
        _lastC.text = p.lastName ?? '';
        _mobileC.text = p.mobile ?? '';
      }
    });
  }

  @override
  void dispose() {
    _firstC.dispose();
    _lastC.dispose();
    _mobileC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final patch = <String, dynamic>{
      'firstName': _firstC.text.trim(),
      'lastName': _lastC.text.trim(),
      'mobile': _mobileC.text.trim(),
      if (_passwordC.text.isNotEmpty) 'password': _passwordC.text,
    };

    final ctrl = ref.read(profileControllerProvider.notifier);
    final p = await ctrl.update(patch);

    if (!mounted) return;
    if (p != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved')),
      );
    } else {
      final err = ref.read(profileControllerProvider).error ?? 'Failed to save';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  Future<void> _logout() async {
    await ref.read(authControllerProvider.notifier).logout();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final profState = ref.watch(profileControllerProvider);
    final authState = ref.watch(authControllerProvider);

    if (profState.error != null && profState.error!.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: ErrorView(
          message: profState.error,
          onRetry: () => ref.read(profileControllerProvider.notifier).refresh(),
        ),
      );
    }

    final p = profState.profile ?? authState.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: profState.isLoading && p == null
                  ? const Center(child: CircularProgressIndicator())
                  : p == null
                  ? const EmptyState(
                title: 'No profile found',
                message: 'Try refreshing or sign in again.',
              )
                  : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    _ReadOnlyField(label: 'Email', value: p.email),
                    const SizedBox(height: 16),

                    // First name
                    AppTextField(
                      controller: _firstC,
                      label: 'First name',
                      prefixIcon: const Icon(Icons.badge_outlined),
                      validator: (v) => null, // optional
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),

                    // Last name
                    AppTextField(
                      controller: _lastC,
                      label: 'Last name',
                      prefixIcon: const Icon(Icons.badge_outlined),
                      validator: (v) => null, // optional
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),

                    // Mobile
                    AppTextField(
                      controller: _mobileC,
                      label: 'Mobile',
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                      v == null || v.isEmpty ? null : Validators.mobile(v),
                      prefixIcon: const Icon(Icons.phone_iphone_outlined),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),

                    // Change password (optional)
                    AppTextField(
                      controller: _passwordC,
                      label: 'New password (optional)',
                      validator: (v) =>
                      v == null || v.isEmpty ? null : Validators.password(v),
                      prefixIcon: const Icon(Icons.lock_reset_outlined),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: profState.isLoading
                            ? 'Saving…'
                            : 'Save changes',
                        isLoading: profState.isLoading,
                        icon: Icons.save_outlined,
                        onPressed: profState.isLoading ? null : _save,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.alternate_email),
      ),
    );
  }
}
