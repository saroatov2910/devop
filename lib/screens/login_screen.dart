import 'package:flutter/material.dart';
import '../utils/utils.dart';

// Login Form widget for user authentication
class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey; // Key for form validation
  final TextEditingController emailController; // Controller for email input
  final TextEditingController
  passwordController; // Controller for password input
  final bool isLoading; // Indicates if loading spinner should show
  final VoidCallback onSubmit; // Callback for login button
  final VoidCallback toggleForm; // Callback for switching to registration

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
    required this.toggleForm,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey, // Assigns the form key for validation
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Email input field
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'אימייל'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              // Checks if email is empty
              if (value == null || value.isEmpty) {
                return 'אנא הזן אימייל';
              }
              // Checks if email format is valid
              if (!Utils.isValidEmail(value)) {
                return 'אנא הזן אימייל תקין';
              }
              return null;
            },
          ),
          const SizedBox(height: 12), // Spacer between fields
          // Password input field
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'סיסמה'),
            obscureText: true,
            validator: (value) {
              // Checks if password is empty
              if (value == null || value.isEmpty) {
                return 'אנא הזן סיסמה';
              }
              // Checks if password meets minimum requirements
              if (!Utils.validatePasswordForLogin(value)) {
                return 'הסיסמה חייבת להיות באורך של לפחות 6 תווים';
              }
              return null;
            },
          ),
          const SizedBox(height: 20), // Spacer before buttons
          // Shows loading spinner or login button
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: onSubmit,
                  child: const Text('התחברות'),
                ),
          // Button to switch to registration form
          TextButton(
            onPressed: toggleForm,
            child: const Text('אין לך חשבון? הירשם'),
          ),
        ],
      ),
    );
  }
}
