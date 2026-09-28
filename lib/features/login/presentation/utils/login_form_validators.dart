class LoginFormValidators {
  const LoginFormValidators._();

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s.]+(\.[^@\s.]+)+$');

  static String? email(String? value) {
    final String email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email address.';
    if (!_emailPattern.hasMatch(email)) return 'Enter a valid email address.';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Enter your password.';
    return null;
  }

  static bool isComplete({
    required String emailAddress,
    required String passwordValue,
  }) =>
      emailAddress.trim().isNotEmpty && passwordValue.isNotEmpty;
}
