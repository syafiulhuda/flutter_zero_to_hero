// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zth/auth/auth_service.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  bool _isLoading = false;

  void _signUp() async {
    setState(() => _isLoading = true);
    try {
      await authService.signUpWithEmailPassword(
        emailController.text,
        passwordController.text,
      );

      final user = authService.getCurrentUser();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign Up Success with email: ${user!.email}")),
      );

      await Future.delayed(const Duration(seconds: 1));

      context.go('/app');
    } on FirebaseAuthException catch (e) {
      _showError(authService.getErrorMessage(e.code));
    } catch (e) {
      _showError('Something went wrong');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text('Sign Up')),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signUp,
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withAlpha(50),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
