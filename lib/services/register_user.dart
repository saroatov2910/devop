import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication package
import 'user_service.dart'; // Service for user profile creation
import '../models/new_user.dart'; // User model

// Registers a new user with email and password, then creates a user profile
Future<User?> registerUser({
  required NewUser newUser, // User data
  required String password, // User password
}) async {
  final auth = FirebaseAuth.instance; // Firebase Auth instance

  try {
    // Create user with email and password in Firebase Auth
    UserCredential result = await auth.createUserWithEmailAndPassword(
      email: newUser.email,
      password: password,
    );

    final user = result.user; // Firebase user object
    if (user != null) {
      // Create user profile in Firestore (or other DB)
      await UserService.createUserProfile(
        userId: user.uid,
        username: newUser.username,
        email: newUser.email,
        phoneNumber: newUser.phoneNumber,
      );
    }

    return user; // Return the created user
  } on FirebaseAuthException catch (e) {
    // Handle registration errors
    throw Exception(e.message);
  }
}
