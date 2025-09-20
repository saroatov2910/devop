import 'package:flutter/material.dart'; // Importing Flutter UI framework
import '../models/new_user.dart'; // Importing the user model

// Profile Screen widget displays user information
class ProfileScreen extends StatelessWidget {
  // Holds the user data to display
  final NewUser newUser;

  // Constructor requires a NewUser object
  const ProfileScreen({super.key, required this.newUser});

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic visual layout structure
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')), // Top app bar with title
      body: Padding(
        padding: const EdgeInsets.all(16), // Adds padding around the content
        child: Column(
          children: [
            const SizedBox(height: 16), // Spacer for top margin
            Text(
              newUser.username, // Displays the user's name
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ), // Large bold text
            ),
            const SizedBox(height: 8), // Spacer between fields
            Text('Email: ${newUser.email}'), // Displays the user's email
            const SizedBox(height: 8), // Spacer between fields
            Text(
              'Phone: ${newUser.phoneNumber}',
            ), // Displays the user's phone number
          ],
        ),
      ),
    );
  }
}
