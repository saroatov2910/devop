import 'package:devop/utils/utils.dart';

class Utils {
  /// Validates if the provided email is in a correct format.
  /// Returns true if valid, false otherwise.
  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    // Password must be at least 6 characters long
    return password.length >= 6 ? false : true;
  }
}
