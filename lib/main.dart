// ignore_for_file: unused_import

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zth/app.dart';
import 'package:flutter_zth/bloc/all_products/products_bloc.dart';
import 'package:flutter_zth/bloc/pagination/pagination_bloc.dart';
import 'package:flutter_zth/bloc/user/user_bloc.dart';
import 'package:flutter_zth/data/pagination_repository.dart';
import 'package:flutter_zth/bloc/single_product/product_bloc.dart';
import 'package:flutter_zth/data/constants.dart';
import 'package:flutter_zth/data/notifier.dart';
// import 'package:flutter_zth/firebase_options_dummy.dart';
import 'package:flutter_zth/firebase_options.dart';
import 'package:flutter_zth/test/test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'routes/route.dart';

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
// ! app-arm64-v8a-release
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = CertificateVerify();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    isFirebaseInitialized.value = true;
    if (kDebugMode) {
      debugPrint('Firebase initialized successfully.');
    }
  } catch (e) {
    isFirebaseInitialized.value = false;
    if (kDebugMode) {
      debugPrint(
        'Firebase initialization failed: $e. Running without Firebase features.',
      );
    }
  }

  final isDark = await ThemeModePreferences().loadThemePreference();
  isDarkModeNotifier.value = isDark;

  final repo = PaginationRepository();
  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  final PaginationRepository repo;
  const MyApp({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductsBloc()),
        BlocProvider(create: (context) => ProductBloc()),
        BlocProvider(create: (context) => PaginationBloc(repo)),
        BlocProvider(create: (context) => UserBloc()),
      ],
      child: App(),
    );
  }
}
