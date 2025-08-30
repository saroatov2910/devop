import 'package:cloud_firestore/cloud_firestore.dart';

/// A service class to handle user-related operations with Firestore.
class UserService {
  // A static reference to the 'users' collection in Firestore.
  static final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');

  /// Creates a new user profile document in the 'users' collection.
  static Future<void> createUserProfile({
    required String userId,
    required String username,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      // Use await to wait for the Future returned by the set method to complete.
      await usersCollection.doc(userId).set({
        'username': username,
        'email': email,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint('User profile for $username created successfully!');
    } catch (e) {
      debugPrint('Error creating user profile: $e');
    }
  }
}
