/// Common form validators used across the app.
/// All functions return `String?` — null means "valid".
class Validators {
  Validators._();

  // ---------- Generic ----------
  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  static String? minLength(String? value, int min, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    if (value.trim().length < min) return '$field must be at least $min characters';
    return null;
  }

  static String? maxLength(String? value, int max, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    if (value.trim().length > max) return '$field must be at most $max characters';
    return null;
  }

  // ---------- Email ----------
  static final RegExp _emailRx = RegExp(
    r"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$",
    caseSensitive: false,
  );

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!_emailRx.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  // ---------- Password (basic rule) ----------
  static String? password(String? value, {int min = 6}) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < min) return 'Password must be at least $min characters';
    return null;
  }

  // ---------- Mobile (basic, digits only 8–15) ----------
  static final RegExp _digitsOnly = RegExp(r'^\d{8,15}$');
  static String? mobile(String? value) {
    if (value == null || value.trim().isEmpty) return 'Mobile number is required';
    final v = value.replaceAll(RegExp(r'\s+'), '');
    if (!_digitsOnly.hasMatch(v)) return 'Enter a valid mobile number';
    return null;
  }

  // ---------- Match (e.g., confirm password) ----------
  static String? matches(String? value, String other,
      {String field = 'This field', String otherField = 'the other value'}) {
    if (value == null || value.isEmpty) return '$field is required';
    if (value != other) return '$field must match $otherField';
    return null;
  }
}
