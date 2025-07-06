import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zth/data/notifier.dart';
import 'package:flutter_zth/firebase_options.dart';
import 'routes/route.dart';

// ! flutter build apk --release --split-per-abi

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
