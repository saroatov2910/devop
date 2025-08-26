class Utils {
  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w\.\+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static String? validatePassword(String password) {
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasNumber = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#\$&*~]'));
    bool longEnough = password.length >= 6;

    if (!hasUppercase) {
      return "Password must contain at least one uppercase letter.";
    }
    if (!hasNumber) {
      return "Password must contain at least one number.";
    }
    if (!hasSpecial) {
      return "Password must contain at least one special character (!@#\$&*~).";
    }
    if (!longEnough) {
      return "Password must be at least 6 characters long.";
    }

    return null;
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    final RegExp phoneRegex = RegExp(r'^\+?[0-9]{9,15}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  static bool isValidUsername(String username) {
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9._]{3,}$');
    return usernameRegex.hasMatch(username);
  }
}
