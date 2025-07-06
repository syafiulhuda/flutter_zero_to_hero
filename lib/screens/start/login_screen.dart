// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_zth/auth/auth_service.dart';
import 'package:flutter_zth/data/constants.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void _login() async {
    setState(() => isLoading = true);
    try {
      await authService.signInWithEmailPassword(
        emailController.text,
        passwordController.text,
      );

      final user = authService.getCurrentUser();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Success with email: ${user!.email}")),
      );

      await Future.delayed(const Duration(seconds: 1));

      context.go('/app');
    } catch (e) {
      _showError(authService.getErrorMessage(e.toString()));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _loginWithGoogle() async {
    setState(() => isLoading = true);
    try {
      await authService.signInWithGoogle();

      final user = authService.getCurrentUser();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Success with email: ${user!.email}")),
      );

      await Future.delayed(const Duration(seconds: 1));

      context.go('/app');
    } catch (e) {
      _showError("Google Sign In Failed");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: emailController,
                      cursorColor: KTextStyle.generalColor(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email Can`t be Empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: const Icon(Icons.email),
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: KTextStyle.generalTextStyle(context),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: KTextStyle.generalColor(context),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      cursorColor: KTextStyle.generalColor(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password Can`t be Empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: const Icon(Icons.password_outlined),
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: KTextStyle.generalTextStyle(context),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: KTextStyle.generalColor(context),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KTextStyle.generalColor(context),
                        minimumSize: Size(screenWidth * .6, 50),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: KTextStyle.generalTextStyle(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        context.go("/signup");
                      },
                      child: Text(
                        "Belum punya akun? Daftar disini!",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Divider(),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: _loginWithGoogle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KTextStyle.generalColor(context),
                        minimumSize: Size(screenWidth * .6, 50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.email_rounded,
                            color: KTextStyle.generalTextStyle(context),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Login with Google",
                            style: TextStyle(
                              color: KTextStyle.generalTextStyle(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
