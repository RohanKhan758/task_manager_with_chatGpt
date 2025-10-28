import 'package:flutter/material.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({
    super.key,
    required this.initialEmail,
    this.initialFirstName,
    this.initialLastName,
    this.initialMobile,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  final String initialEmail;
  final String? initialFirstName;
  final String? initialLastName;
  final String? initialMobile;
  final bool isSubmitting;

  /// Returns a patch map like:
  /// { firstName, lastName, mobile, password? }
  final Future<void> Function(Map<String, dynamic> patch) onSubmit;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstC;
  late final TextEditingController _lastC;
  late final TextEditingController _mobileC;
  final _passwordC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstC = TextEditingController(text: widget.initialFirstName ?? '');
    _lastC = TextEditingController(text: widget.initialLastName ?? '');
    _mobileC = TextEditingController(text: widget.initialMobile ?? '');
  }

  @override
  void dispose() {
    _firstC.dispose();
    _lastC.dispose();
    _mobileC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final patch = <String, dynamic>{
      'firstName': _firstC.text.trim(),
      'lastName': _lastC.text.trim(),
      'mobile': _mobileC.text.trim(),
      if (_passwordC.text.isNotEmpty) 'password': _passwordC.text,
    };
    await widget.onSubmit(patch);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Read-only email
          TextFormField(
            initialValue: widget.initialEmail,
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.alternate_email),
            ),
          ),
          const SizedBox(height: 12),

          AppTextField(
            controller: _firstC,
            label: 'First name',
            prefixIcon: const Icon(Icons.badge_outlined),
          ),
          const SizedBox(height: 12),

          AppTextField(
            controller: _lastC,
            label: 'Last name',
            prefixIcon: const Icon(Icons.badge_outlined),
          ),
          const SizedBox(height: 12),

          AppTextField(
            controller: _mobileC,
            label: 'Mobile',
            keyboardType: TextInputType.phone,
            validator: (v) =>
            v == null || v.isEmpty ? null : Validators.mobile(v),
            prefixIcon: const Icon(Icons.phone_iphone_outlined),
          ),
          const SizedBox(height: 12),

          AppTextField(
            controller: _passwordC,
            label: 'New password (optional)',
            validator: (v) =>
            v == null || v.isEmpty ? null : Validators.password(v),
            prefixIcon: const Icon(Icons.lock_reset_outlined),
            obscureText: true,
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: widget.isSubmitting ? 'Saving…' : 'Save changes',
              isLoading: widget.isSubmitting,
              icon: Icons.save_outlined,
              onPressed: widget.isSubmitting ? null : _submit,
            ),
          ),
        ],
      ),
    );
  }
}
