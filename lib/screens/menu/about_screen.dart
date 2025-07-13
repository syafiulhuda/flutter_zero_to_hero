// lib/screens/menu/about_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_zth/auth/auth_service.dart';
import 'package:flutter_zth/data/constants.dart';
import 'package:flutter_zth/data/notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, isLoggingOut, _) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: KTextStyle.generalColor(context),
                title: const Text("About"),
                actions: [
                  ValueListenableBuilder(
                    valueListenable: isDarkModeNotifier,
                    builder: (context, selectedMode, child) {
                      return Switch(
                        thumbIcon: WidgetStateProperty.resolveWith<Icon?>((
                          states,
                        ) {
                          return selectedMode
                              ? Icon(
                                Icons.light_mode,
                                color: colorScheme.onSurface,
                              )
                              : Icon(
                                Icons.dark_mode,
                                color: colorScheme.onSurface,
                              );
                        }),
                        trackOutlineColor: WidgetStateProperty.all(
                          selectedMode
                              ? colorScheme.primaryContainer
                              : colorScheme.tertiary,
                        ),
                        trackColor: WidgetStateProperty.all(
                          selectedMode
                              ? colorScheme.primary
                              : colorScheme.tertiaryContainer,
                        ),
                        thumbColor: WidgetStateProperty.all(
                          KTextStyle.generalColor(context),
                        ),
                        value: !selectedMode,
                        onChanged: (value) {
                          isDarkModeNotifier.value = !isDarkModeNotifier.value;

                          // Save changeMode ke sharePreferences
                          ThemeModePreferences().saveThemeMode(!value);
                          debugPrint("${!isDarkModeNotifier.value}");
                        },
                      );
                    },
                  ),
                ],
              ),
              body: Body(),
            ),
            if (isLoggingOut)
              Container(
                color: Colors.black.withAlpha(30),
                child: Center(
                  child: LottieBuilder.asset("assets/splash/loading-hand.json"),
                ),
              ),
          ],
        );
      },
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return FutureBuilder<User?>(
      future: authService.getCurrentUser(),
      builder: (context, snapshot) {
        final User? user = snapshot.data;

        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;

        double avatarRadius = width * .22;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  maxRadius: avatarRadius,
                  child: ShaderMask(
                    shaderCallback:
                        (bounds) => LinearGradient(
                          colors: [Colors.pinkAccent, Colors.purple.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                    child: Icon(
                      Icons.flutter_dash,
                      size: avatarRadius * 2 * .6,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    (user?.email != null || user?.displayName != null)
                        ? "${user?.displayName ?? user?.email?.split('@').first}"
                        : "No Name!",
                    textAlign: TextAlign.center,
                    style: KTextStyle.bodyTextStyle(context),
                  ),
                ),
                SizedBox(height: height * .3),
                ValueListenableBuilder<bool>(
                  valueListenable: isLoading,
                  builder: (context, isLoggingOut, child) {
                    return ElevatedButton(
                      onPressed:
                          isLoggingOut
                              ? null
                              : () async {
                                isLoading.value = true;

                                await Future.delayed(
                                  const Duration(milliseconds: 500),
                                );

                                await authService.signOut();

                                if (context.mounted) {
                                  await Future.delayed(
                                    const Duration(milliseconds: 50),
                                  );
                                  if (context.mounted) {
                                    context.go('/login');
                                  }
                                }
                                isLoading.value = false;
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KTextStyle.generalColor(context),
                        minimumSize: Size(width * .4, 50),
                      ),
                      child: Text(
                        "Log Out",
                        style: KTextStyle.bodyTextStyle(context),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
