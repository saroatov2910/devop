// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    final userEmail = _authService.currentUser?.email ?? "User";

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, $userEmail"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        // This is a placeholder for your home screen content
        color: Colors.orange,
        child: const Center(
          child: Text(
            "Home Screen",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
      // Here's where the BottomNav widget goes.
      bottomNavigationBar: BottomNav(
        onItemTap: (index) {
          print("Tapped item index: $index");
          // You would handle navigation here based on the index
          // For example: if (index == 0) { show Home page }
        },
      ),
    );
  }
}
