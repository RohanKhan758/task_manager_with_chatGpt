import 'package:flutter/material.dart';

/// A consistent primary button for the whole app.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;

    return FilledButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: isLoading
          ? const SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
          : Icon(icon ?? Icons.check),
      label: Text(label),
    );
  }
}
