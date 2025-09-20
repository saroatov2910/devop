// class functions:
// isValidEmail
// validatePasswordForRegistration:
// validatePasswordForLogin:
// isValidPhoneNumber:
// isValidUsername:

class Utils {
  static bool isValidEmail(String email) =>
      email.contains('@') && email.contains('.');

  static String? validatePasswordForRegistration(String password) {
    if (password.length < 6) return 'הסיסמה חייבת לפחות 6 תווים';
    return null;
  }

  static bool validatePasswordForLogin(String password) => password.length >= 6;

  static bool isValidPhoneNumber(String phoneNumber) =>
      phoneNumber.length >= 9 && phoneNumber.length <= 12;

  static bool isValidUsername(String username) => username.length >= 3;
}
