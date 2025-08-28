import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import '../models/products/product.dart';
import '../widgets/product_list_tile.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService authService = AuthService();
  final ProductService productService = ProductService();
  bool showLogin = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    try {
      await authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Added mounted check ✅
      // Prevents calling ScaffoldMessenger or other context-dependent code
      // if the widget has been removed from the widget tree while async code is still running
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login successful")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        await authService.register(
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
        );
        setState(() => showLogin = true);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(showLogin ? "Login" : "Register")),
      body: Stack(
        children: [
          StreamBuilder<List<Product>>(
            stream: productService.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("שגיאה בטעינת מוצרים: ${snapshot.error}"),
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final products = snapshot.data!;
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductListTile(
                    product: product,
                    onTap: () {
                      productService.updateProductChecked(
                        product.id,
                        !product.checked,
                      );
                    },
                  );
                },
              );
            },
          ),
          Container(
            color: Colors.white.withOpacity(0.8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: showLogin ? _buildLoginForm() : _buildRegisterForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: "Email"),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Password"),
        ),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: _login, child: const Text("Login")),
        TextButton(
          onPressed: () => setState(() => showLogin = false),
          child: const Text("Don't have an account? Register"),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: "Username"),
            validator: (val) => val!.length >= 3 ? null : "שם משתמש קצר מדי",
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email"),
            validator: (val) => val!.contains('@') ? null : "אימייל לא תקין",
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password"),
            validator: (val) => val!.length >= 6 ? null : "סיסמה קצרה מדי",
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: "Phone Number"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _register, child: const Text("Register")),
          TextButton(
            onPressed: () => setState(() => showLogin = true),
            child: const Text("Already have an account? Login"),
          ),
        ],
      ),
    );
  }
}
