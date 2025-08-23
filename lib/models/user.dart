// lib/models/user.dart
// this is the base user class for all users in the app
// it contains common properties like username, password, email, and phoneNumber

abstract class User {
  // common properties for all users
  late String username;
  late String password;
  late String email;
  late String phoneNumber;
  late String userId;

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.userId,
  });
}
