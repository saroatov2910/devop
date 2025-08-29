// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> register({
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'username': username,
          'email': email,
          'phoneNumber': phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      throw Exception("שגיאה בהרשמה: $e");
    }
  }

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("לא נמצא משתמש עם כתובת האימייל הזאת");
      } else if (e.code == 'wrong-password') {
        throw Exception("סיסמה שגויה, נסה שוב");
      } else if (e.code == 'invalid-email') {
        throw Exception("כתובת האימייל לא תקינה");
      } else if (e.code == 'user-disabled') {
        throw Exception("המשתמש הזה הושבת");
      } else {
        throw Exception("שגיאה בהתחברות: ${e.message}");
      }
    } catch (e) {
      throw Exception("שגיאה כללית בהתחברות: $e");
    }
  }
}
