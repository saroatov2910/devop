import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase core initialization
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication
import 'screens/home_screen.dart'; // Home screen import
import 'screens/auth_screen.dart'; // Authentication screen import
import 'firebase_options.dart'; // Firebase options for platform

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Devop App',
      home: const AuthCheck(),
      routes: {
        '/home': (context) {
          final user = FirebaseAuth.instance.currentUser;
          return HomeScreen(userEmail: user?.email ?? "User");
        },
        '/login': (context) => const AuthScreen(),
      },
    );
  }
}

// Widget that checks authentication state and shows the correct screen
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return HomeScreen(userEmail: snapshot.data!.email ?? "User");
        }

        return const AuthScreen();
      },
    );
  }
}
