import 'package:flutter/material.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  final Future<void> Function({
  required String email,
  required String password,
  }) onSubmit;
  final bool isSubmitting;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
    await widget.onSubmit(email: _emailC.text.trim(), password: _passwordC.text);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            controller: _emailC,
            label: 'Email',
            hint: 'you@example.com',
            prefixIcon: const Icon(Icons.email_outlined),
            validator: Validators.email,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _passwordC,
            label: 'Password',
            hint: 'Minimum 6 characters',
            prefixIcon: const Icon(Icons.lock_outline),
            validator: (v) => Validators.password(v, min: 6),
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: widget.isSubmitting ? 'Signing in…' : 'Sign in',
              isLoading: widget.isSubmitting,
              icon: Icons.login,
              onPressed: widget.isSubmitting ? null : _submit,
            ),
          ),
        ],
      ),
    );
  }
}
