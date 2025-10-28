import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import 'package:task_manager/features/auth/providers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();

  @override
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final auth = ref.read(authControllerProvider.notifier);
    final token = await auth.login(
      email: _emailC.text.trim(),
      password: _passwordC.text,
    );

    final state = ref.read(authControllerProvider);
    if (mounted) {
      if (token != null && state.isLoggedIn) {
        context.go('/home');
      } else if (state.error != null && state.error!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Welcome back',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to manage your tasks',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

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
                    const SizedBox(height: 16),

                    // Password
                    AppTextField(
                      controller: _passwordC,
                      label: 'Password',
                      hint: 'Your password',
                      validator: (v) => Validators.password(v, min: 6),
                      prefixIcon: const Icon(Icons.lock_outline),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 24),

                    // Submit
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: authState.isSubmitting ? 'Signing in…' : 'Sign in',
                        isLoading: authState.isSubmitting,
                        icon: Icons.login,
                        onPressed: authState.isSubmitting ? null : _submit,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Below the Sign in button area, add:
                    TextButton.icon(
                      onPressed: authState.isSubmitting ? null : () => context.push('/forgot'),
                      icon: const Icon(Icons.help_outline),
                      label: const Text('Forgot password?'),
                    ),

                    const SizedBox(height: 12),

                    // Registration shortcut (screen comes later)
                    TextButton.icon(
                      onPressed: authState.isSubmitting
                          ? null
                          : () => context.push('/register'),
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text('Create a new account'),
                    ),

                    const SizedBox(height: 24),

                    // Error message (if any)
                    if (authState.error != null && authState.error!.isNotEmpty)
                      Text(
                        authState.error!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                        textAlign: TextAlign.center,
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
