// lib/models/user.dart
// this is the base user class for all users in the app
// it contains common properties like username, password, email, and phoneNumber

abstract class User {
  late String username;
  late String password;
  late String email;
  late String phoneNumber;
  late String userId;
  late DateTime createdAt;
  bool isVerified;

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.userId,
    DateTime? createdAt,
    this.isVerified = false,
  }) : createdAt = createdAt ?? DateTime.now();

  // method to convert user object to a map for easier storage in Firestore
  // especially useful when registering a new user
  // and you want to save their details in the database
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
    };
  }
}
