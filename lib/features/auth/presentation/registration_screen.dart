import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import 'package:task_manager/features/auth/providers/auth_controller.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();
  final _confirmC = TextEditingController();
  final _firstNameC = TextEditingController();
  final _lastNameC = TextEditingController();
  final _mobileC = TextEditingController();

  @override
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    _confirmC.dispose();
    _firstNameC.dispose();
    _lastNameC.dispose();
    _mobileC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final auth = ref.read(authControllerProvider.notifier);
    final profile = await auth.register(
      email: _emailC.text.trim(),
      password: _passwordC.text,
      firstName: _firstNameC.text.trim().isEmpty ? null : _firstNameC.text.trim(),
      lastName: _lastNameC.text.trim().isEmpty ? null : _lastNameC.text.trim(),
      mobile: _mobileC.text.trim().isEmpty ? null : _mobileC.text.trim(),
    );

    final state = ref.read(authControllerProvider);
    if (mounted) {
      if (profile != null && state.error?.isNotEmpty != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful. Please sign in.')),
        );
        context.go('/login');
      } else if (state.error != null && state.error!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Join Task Manager',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    AppTextField(
                      controller: _emailC,
                      label: 'Email',
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                      prefixIcon: const Icon(Icons.email_outlined),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),

                    // Password
                    AppTextField(
                      controller: _passwordC,
                      label: 'Password',
                      hint: 'Minimum 6 characters',
                      validator: (v) => Validators.password(v, min: 6),
                      prefixIcon: const Icon(Icons.lock_outline),
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),

                    // Confirm Password
                    AppTextField(
                      controller: _confirmC,
                      label: 'Confirm password',
                      validator: (v) => Validators.matches(v, _passwordC.text,
                          field: 'Confirm password', otherField: 'password'),
                      prefixIcon: const Icon(Icons.lock_reset_outlined),
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),

                    // First name
                    AppTextField(
                      controller: _firstNameC,
                      label: 'First name (optional)',
                      prefixIcon: const Icon(Icons.badge_outlined),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),

                    // Last name
                    AppTextField(
                      controller: _lastNameC,
                      label: 'Last name (optional)',
                      prefixIcon: const Icon(Icons.badge_outlined),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),

                    // Mobile
                    AppTextField(
                      controller: _mobileC,
                      label: 'Mobile (optional)',
                      keyboardType: TextInputType.phone,
                      validator: (v) => v == null || v.isEmpty ? null : Validators.mobile(v),
                      prefixIcon: const Icon(Icons.phone_iphone_outlined),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                    ),

                    const SizedBox(height: 24),

                    // Submit
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: state.isSubmitting ? 'Creating account…' : 'Create account',
                        isLoading: state.isSubmitting,
                        icon: Icons.person_add_alt_1,
                        onPressed: state.isSubmitting ? null : _submit,
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextButton.icon(
                      onPressed: state.isSubmitting ? null : () => context.go('/login'),
                      icon: const Icon(Icons.login),
                      label: const Text('Back to Sign in'),
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
