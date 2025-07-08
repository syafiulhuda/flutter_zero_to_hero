import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zth/data/constants.dart';
import 'package:flutter_zth/data/notifier.dart';
import 'package:flutter_zth/routes/route.dart';
import 'package:flutter_zth/widgets/circular_menu_widget.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Material(
          color: Colors.transparent,
          child: Text(
            // user?.email != null
            //     ? "Hai ${user?.displayName}!"
            //     : "Hai ${user?.email}!",
            // "Hai ${user?.displayName ?? user?.email?.split('@').first ?? 'Pengguna'}!",
            (user?.email != null || user?.displayName != null)
                ? "Hai ${user?.displayName ?? user?.email?.split('@').first}!"
                : "Hai Pengguna!",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: isDarkModeNotifier,
            builder: (context, selectedMode, child) {
              return Switch.adaptive(
                thumbIcon: WidgetStateProperty.resolveWith<Icon?>((
                  Set<WidgetState> states,
                ) {
                  if (selectedMode) {
                    return Icon(Icons.light_mode, color: colorScheme.onSurface);
                  }
                  return Icon(Icons.dark_mode, color: colorScheme.onSurface);
                }),
                trackOutlineColor: WidgetStateProperty.resolveWith((states) {
                  if (selectedMode) {
                    return colorScheme.primaryContainer;
                  }
                  return colorScheme.tertiary;
                }),
                trackColor: WidgetStateProperty.resolveWith((states) {
                  if (selectedMode) {
                    return colorScheme.primary;
                  }
                  return colorScheme.tertiaryContainer;
                }),
                thumbColor: WidgetStateProperty.resolveWith((states) {
                  if (selectedMode) {
                    return colorScheme.inversePrimary;
                  }
                  return colorScheme.inversePrimary;
                }),
                value: !selectedMode,
                onChanged: (value) {
                  isDarkModeNotifier.value = !isDarkModeNotifier.value;

                  // Save changeMode ke sharePreferences
                  ThemeModePreferences().saveThemeMode(!value);
                  debugPrint("${!value}"); // Dark Mode = false
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: appRoutes.length,
        itemBuilder: (context, index) {
          final routeItem = appRoutes[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8),
              title: Text(
                routeItem.title,
                style: KTextStyle.bodyTextStyle(context),
              ),
              subtitle: Text(
                'Path: `${routeItem.path}`',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: KTextStyle.generalColor(context),
                size: 20,
              ),
              onTap: () {
                context.push(routeItem.path);
              },
            ),
          );
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: CircularMenuWidget(),
    );
  }
}
