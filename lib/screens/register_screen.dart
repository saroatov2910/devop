import 'package:flutter/material.dart';
import '../utils/utils.dart';

// Register Form widget for user registration
class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey; // Key for form validation
  final TextEditingController emailController; // Controller for email input
  final TextEditingController
  passwordController; // Controller for password input
  final TextEditingController
  usernameController; // Controller for username input
  final TextEditingController phoneController; // Controller for phone input
  final bool isLoading; // Indicates if loading spinner should show
  final VoidCallback onSubmit; // Callback for register button
  final VoidCallback toggleForm; // Callback for switching to login

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.usernameController,
    required this.phoneController,
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
          // Username input field
          TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: 'שם משתמש'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'אנא הזן שם משתמש';
              }
              if (!Utils.isValidUsername(value)) {
                return 'שם משתמש חייב להיות לפחות 3 תווים באנגלית/מספרים/נקודה/קו תחתון';
              }
              return null;
            },
          ),
          const SizedBox(height: 12), // Spacer between fields
          // Email input field
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'אימייל'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'אנא הזן אימייל';
              }
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
              if (value == null || value.isEmpty) {
                return 'אנא הזן סיסמה';
              }
              final passwordError = Utils.validatePasswordForRegistration(
                value,
              );
              if (passwordError != null) {
                return passwordError;
              }
              return null;
            },
          ),
          const SizedBox(height: 12), // Spacer between fields
          // Phone number input field
          TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'מספר טלפון'),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'אנא הזן מספר טלפון';
              }
              if (!Utils.isValidPhoneNumber(value)) {
                return 'מספר טלפון לא תקין';
              }
              return null;
            },
          ),
          const SizedBox(height: 20), // Spacer before buttons
          // Shows loading spinner or register button
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade400,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('הרשמה'),
                ),
          // Button to switch to login form
          TextButton(
            onPressed: toggleForm,
            child: const Text('כבר יש לך חשבון? התחבר'),
          ),
        ],
      ),
    );
  }
}
