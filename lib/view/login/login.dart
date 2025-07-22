import 'package:flutter/material.dart';
import 'package:workout_fitness/api/network_service.dart';
import 'package:workout_fitness/view/home/home_view.dart';

import '../../data/services/Preferences.dart';
import '../menu/menu_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Controllers for text input fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Focus nodes for managing input focus
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // To manage password visibility
  bool _isPasswordVisible = false;

  // Login function (you'll implement actual authentication logic)
  void _handleLogin() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Unfocus all text fields before login
      _usernameFocusNode.unfocus();
      _passwordFocusNode.unfocus();

      final String username = _usernameController.text;
      final String password = _passwordController.text;

      // Validate input fields
      if (username.isEmpty || password.isEmpty) {
        throw Exception('Username and password cannot be empty');
      }

      final response = await NetworkService.instance
          .post('/auth/login', body: {'username': username, 'password': password});


      // Remove loading indicator
      Navigator.of(context).pop();

      // Store JWT token
      await Preferences.setJwtSecret(response['access_token']);

      // Fetch user details
      final user = await NetworkService.instance.get('/users/me');

      await Preferences.setUserId(user["id"]);

      await Preferences.setUsername(username);

      // Navigate to next screen or perform post-login actions
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MenuView(),
        ),
      );
    } catch (e) {
      // Remove loading indicator
      Navigator.of(context).pop();

      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: Text(
              'An unexpected error occurred. Please try again.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      // Optional: Log the error
      print('Login error: $e');
    }
  }

  @override
  void dispose() {
    // Clean up controllers and focus nodes when the widget is disposed
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Detect taps outside of input fields to unfocus
      onTap: () {
        // Unfocus all text fields when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Username TextField
              TextField(
                controller: _usernameController,
                focusNode: _usernameFocusNode,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                // Move focus to password field when done with username
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
              const SizedBox(height: 16),

              // Password TextField
              TextField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: !_isPasswordVisible,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                onEditingComplete: _handleLogin,
              ),
              const SizedBox(height: 24),

              // Login Button
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
