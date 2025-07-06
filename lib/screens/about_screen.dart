import 'package:flutter/material.dart';
import 'package:flutter_zth/auth/auth_service.dart';
import 'package:flutter_zth/data/constants.dart';
import 'package:flutter_zth/data/notifier.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: KTextStyle.generalColor(context),
        title: const Text("About"),
        actions: [
          // Tombol Logout
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
          // Switch Mode (Dark/Light)
          ValueListenableBuilder(
            valueListenable: isDarkModeNotifier,
            builder: (context, selectedMode, child) {
              return Switch(
                thumbIcon: WidgetStateProperty.resolveWith<Icon?>((
                  Set<WidgetState> states,
                ) {
                  return selectedMode
                      ? Icon(Icons.light_mode, color: colorScheme.onSurface)
                      : Icon(Icons.dark_mode, color: colorScheme.onSurface);
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
                },
              );
            },
          ),
        ],
      ),
      body: const Center(child: Text("This is the About Screen")),
    );
  }
}
