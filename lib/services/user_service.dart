import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package

class UserService {
  // Reference to the "users" collection in Firestore
  static final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');

  // Creates a user profile document in Firestore
  static Future<void> createUserProfile({
    required String userId, // User ID
    required String username, // Username
    required String email, // Email address
    required String phoneNumber, // Phone number
  }) async {
    await usersCollection.doc(userId).set({
      'username': username, // Store username
      'email': email, // Store email
      'phoneNumber': phoneNumber, // Store phone number
      'createdAt': FieldValue.serverTimestamp(), // Store creation time
    });
  }
}
