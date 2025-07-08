import 'package:flutter/material.dart';
import 'package:flutter_zth/data/notifier.dart';
import 'package:flutter_zth/routes/route.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, selectedMode, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Zero to Hero',
          routerConfig: goRoute,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: selectedMode ? Colors.deepPurple : Colors.white,
              brightness: selectedMode ? Brightness.light : Brightness.dark,
            ),
          ),
        );
      },
    );
  }
}
