import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase authentication package

// Signs in a user with email and password using Firebase Auth
Future<User?> signInUser({
  required String email, // User email
  required String password, // User password
}) async {
  final auth = FirebaseAuth.instance; // Get Firebase Auth instance
  try {
    // Attempt to sign in with email and password
    UserCredential result = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user; // Return the signed-in user
  } on FirebaseAuthException catch (e) {
    // If sign-in fails, throw an exception with the error message
    throw Exception(e.message);
  }
}
