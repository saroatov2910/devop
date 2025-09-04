// Utility class with validation functions for user input
class Utils {
  // Checks if the email contains '@' and '.'
  static bool isValidEmail(String email) =>
      email.contains('@') && email.contains('.');

  // Validates password for registration (must be at least 6 characters)
  static String? validatePasswordForRegistration(String password) {
    if (password.length < 6) return 'הסיסמה חייבת לפחות 6 תווים';
    return null;
  }

  // Validates password for login (must be at least 6 characters)
  static bool validatePasswordForLogin(String password) => password.length >= 6;

  // Checks if phone number length is between 9 and 12 digits
  static bool isValidPhoneNumber(String phoneNumber) =>
      phoneNumber.length >= 9 && phoneNumber.length <= 12;

  // Checks if username is at least 3 characters
  static bool isValidUsername(String username) => username.length >