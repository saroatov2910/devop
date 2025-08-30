import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');

  static Future<void> createUserProfile({
    required String uid,
    required String username,
    required String email,
    required String phoneNumber,
  }) async {
    await usersCollection.doc(uid).set({
      'uid': uid,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
