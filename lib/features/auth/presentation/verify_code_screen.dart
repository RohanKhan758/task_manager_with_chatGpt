import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../providers/auth_controller.dart';

class VerifyCodeScreen extends ConsumerStatefulWidget {
  const VerifyCodeScreen({super.key, required this.email});
  final String email;

  @override
  ConsumerState<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends ConsumerState<VerifyCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpC = TextEditingController();

  @override
  void dispose() {
    _otpC.dispose();
    super.dispose();
  }

  String? _validateOtp(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Enter the verification code';
    if (s.length < 4) return 'Code looks too short';
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // STEP 2: Verify OTP with the server first
    final ok = await ref.read(authControllerProvider.notifier).verifyOtp(
      email: widget.email,
      otp: _otpC.text.trim(),
    );

    if (!mounted) return;

    if (ok) {
      // On success, go to Reset screen and pass email + otp
      // NOTE: adjust path if you renamed it (e.g., '/auth/reset')
      context.push('/auth/reset', extra: {
        'email': widget.email,
        'otp': _otpC.text.trim(),
      });
    } else {
      final err = ref.read(authControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err?.toString() ?? 'OTP verification failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isSubmitting;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify code')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('We sent a code to ${widget.email}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _otpC,
                    label: 'Verification code',
                    hint: 'Enter the code',
                    prefixIcon: const Icon(Icons.verified_outlined),
                    validator: _validateOtp,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: isLoading ? 'Verifying…' : 'Continue',
                      isLoading: isLoading,
                      icon: Icons.arrow_forward,
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
