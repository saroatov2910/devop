// lib/models/new_user.dart
// this class represents a new user registering in the app
// it extends the base User class and can have additional properties or methods specific to new users
// for now, it just uses the properties from the User class
import 'package:uuid/uuid.dart';

import 'user.dart';

class NewUser extends User {
  NewUser({
    required String username,
    required String password,
    required String email,
    required String phoneNumber,
  }) : super(
         username: username,
         password: password,
         email: email,
         phoneNumber: phoneNumber,
         userId: Uuid().v4(), // יוצרת מזהה ייחודי חדש
       );
}
