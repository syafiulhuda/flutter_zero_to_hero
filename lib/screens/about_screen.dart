import 'package:flutter/material.dart';
import 'package:flutter_zth/auth/auth_service.dart';
import 'package:flutter_zth/data/constants.dart';
import 'package:flutter_zth/data/notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final authService = AuthService();

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
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Logout',
                    onPressed: () async {
                      isLoading.value = true;

                      await Future.delayed(const Duration(seconds: 2));
                      await authService.signOut();

                      isLoading.value = false;

                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                  ),
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
                          debugPrint("${!isDarkModeNotifier.value}"); // true
                        },
                      );
                    },
                  ),
                ],
              ),
              body: const Center(child: Text("This is the About Screen")),
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
