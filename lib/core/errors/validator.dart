String? validInput(String val, int min, int max, String type) {
  
  if (type == 'url') {
  final uri = Uri.tryParse(val);

  if (uri == null ||
      !uri.hasAuthority ||
      !['http', 'https'].contains(uri.scheme) ||
      uri.host.isEmpty) {
    return 'Invalid URL';
  }
}
  // Check the type of input
  if (type == 'username') {
    // Ensure the username consists only of letters and numbers, and starts with a letter
    if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{4,}$').hasMatch(val)) {
      return 'Invalid username';
    }
  }

  if (type == 'email') {
    // Check the validity of the email
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
      return 'Invalid email';
    }
  }

  if (type == 'phone') {
    // Check the validity of the phone number
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(val)) {
      return 'Invalid phone number';
    }
  }
  if (type == 'password') {
    // تأكد من أن كلمة المرور تتكون على الأقل من 6 أحرف، ولا تفرض قيود على نوعية الأحرف
    if (val.length < 6) {
      return 'Password must be at least 6 characters long';
    }
  }
  // Check if the input is empty
  if (val.isEmpty) {
    return "Cannot be empty";
  }

  // Check the length of the input
  if (val.length < min) {
    return "Cannot be less than $min characters";
  }
  if (val.length > max) {
    return "Cannot be more than $max characters";
  }

  // If everything is correct, return null
  return null;
}