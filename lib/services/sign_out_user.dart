import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase authentication package

// Signs out the current user from Firebase Auth
Future<void> signOutUser() async {
  await FirebaseAuth.instance.signOut(); // Perform sign out
}
