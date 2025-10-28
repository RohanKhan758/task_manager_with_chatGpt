import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../providers/auth_controller.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.email,
    this.initialOtp = '',
  });

  final String email;
  final String initialOtp; // allows prefill when coming from Verify step

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpC = TextEditingController();
  final _passC = TextEditingController();
  final _confirmC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _otpC.text = widget.initialOtp;
  }

  @override
  void dispose() {
    _otpC.dispose();
    _passC.dispose();
    _confirmC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final ok = await ref.read(authControllerProvider.notifier).applyNewPassword(
      email: widget.email,
      otp: _otpC.text.trim(),
      newPassword: _passC.text,
    );
    final err = ref.read(authControllerProvider).error;

    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successful. Please sign in.')),
      );
      Navigator.of(context).popUntil((r) => r.isFirst); // back to login
    } else if (err != null && err.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isSubmitting;

    return Scaffold(
      appBar: AppBar(title: const Text('Reset password')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text('Email: ${widget.email}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _otpC,
                    label: 'Verification code',
                    hint: '6-digit code',
                    prefixIcon: const Icon(Icons.verified_outlined),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),

                  AppTextField(
                    controller: _passC,
                    label: 'New password',
                    validator: (v) => Validators.password(v, min: 6),
                    prefixIcon: const Icon(Icons.lock_outline),
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),

                  AppTextField(
                    controller: _confirmC,
                    label: 'Confirm password',
                    validator: (v) => Validators.matches(
                      v,
                      _passC.text,
                      field: 'Confirm password',
                      otherField: 'password',
                    ),
                    prefixIcon: const Icon(Icons.lock_reset_outlined),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: isLoading ? 'Resetting…' : 'Reset password',
                      isLoading: isLoading,
                      icon: Icons.check_circle_outline,
                      onPressed: isLoading ? null : _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
