import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../services/register_user.dart';
import '../services/sign_in_user.dart';
import '../models/new_user.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLogin = true;
  bool isLoading = false;

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerUsernameController = TextEditingController();
  final registerPhoneController = TextEditingController();

  void toggleForm() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  Future<void> handleLogin() async {
    if (!loginFormKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      final user = await signInUser(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text.trim(),
      );
      if (user != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomeScreen(userEmail: user.email ?? "User"),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("אימייל או סיסמה שגויים")),
          );
        }
      }
    } catch (e) {
      debugPrint('Login error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("שגיאה בהתחברות: $e")));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> handleRegister() async {
    if (!registerFormKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      final newUser = NewUser(
        username: registerUsernameController.text.trim(),
        email: registerEmailController.text.trim(),
        phoneNumber: registerPhoneController.text.trim(),
      );
      final user = await registerUser(
        newUser: newUser,
        password: registerPasswordController.text.trim(),
      );
      if (user != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomeScreen(userEmail: user.email ?? "User"),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("שגיאה בהרשמה: $e")));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: showLogin
            ? LoginForm(
                formKey: loginFormKey,
                emailController: loginEmailController,
                passwordController: loginPasswordController,
                isLoading: isLoading,
                onSubmit: handleLogin,
                toggleForm: toggleForm,
              )
            : RegisterForm(
                formKey: registerFormKey,
                emailController: registerEmailController,
                passwordController: registerPasswordController,
                usernameController: registerUsernameController,
                phoneController: registerPhoneController,
                isLoading: isLoading,
                onSubmit: handleRegister,
                toggleForm: toggleForm,
              ),
      ),
    );
  }
}
