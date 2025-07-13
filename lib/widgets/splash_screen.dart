// ignore_for_file: use_build_context_synchronously, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zth/auth/auth_service.dart';
import 'package:flutter_zth/data/notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    final user = await AuthService().getCurrentUser();
    if (user != null) {
      context.go("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;

    return Container(
      height: heightScreen,
      width: widthScreen,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x000fffff),
            Color(0xFF6dd5ed),
            Color(0x000fffff),
            Color(0xFF2193b0),
            Color(0x000fffff),
          ],
        ),
      ),
      child: Center(
        child: GestureDetector(
          onTap: () async {
            final currentContext = context;
            setState(() => isTapped = true);
            await Future.delayed(const Duration(seconds: 2));
            if (!mounted) return;
            currentContext.go('/login');
          },
          child:
              isTapped
                  ? Lottie.asset("assets/splash/loading.json")
                  : Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Lottie.asset("assets/splash/welcome.json"),
                  ),
        ),
      ),
    );
  }
}
