// ignore_for_file: unused_import

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zth/app.dart';
import 'package:flutter_zth/bloc/all_products/products_bloc.dart';
import 'package:flutter_zth/bloc/single_product/product_bloc.dart';
import 'package:flutter_zth/data/constants.dart';
import 'package:flutter_zth/data/notifier.dart';
import 'package:flutter_zth/firebase_options.dart';
import 'package:flutter_zth/test/test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'routes/route.dart';

// void main() => runApp(const Test());

// ! Handling CERTIFICATE_VERIFY_FAILED
class CertificateVerify extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// ! flutter build apk --release --split-per-abi
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  HttpOverrides.global = CertificateVerify();

  final isDark = await ThemeModePreferences().loadThemePreference();
  isDarkModeNotifier.value = isDark;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductsBloc()),
        BlocProvider(create: (context) => ProductBloc()),
      ],
      child: App(),
    );
  }
}
