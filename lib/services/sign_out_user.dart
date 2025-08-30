import 'package:firebase_auth/firebase_auth.dart';

/// Signs out the current user from Firebase Authentication.
Future<void> signOutUser() async {
  try {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    print('User signed out successfully!');
  } on FirebaseAuthException catch (e) {
    print('Firebase Auth error during sign out: ${e.code}');
  } catch (e) {
    print('An unexpected error occurred during sign out: $e');
  }
}
