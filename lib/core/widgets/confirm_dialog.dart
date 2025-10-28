import 'package:flutter/material.dart';

/// Shows a platform-neutral confirm dialog.
/// Returns true if user confirms, false if cancels, null if dismissed.
Future<bool?> showConfirmDialog(
    BuildContext context, {
      required String title,
      String? message,
      String confirmText = 'Confirm',
      String cancelText = 'Cancel',
      bool destructive = false,
    }) {
  final colorScheme = Theme.of(context).colorScheme;

  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: message != null ? Text(message) : null,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          FilledButton(
            style: destructive
                ? FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            )
                : null,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}
