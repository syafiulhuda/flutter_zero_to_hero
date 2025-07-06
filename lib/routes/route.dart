// lib/routes/route.dart
// ignore_for_file: unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:flutter_zth/app.dart';
import 'package:flutter_zth/screens/drawer_screen.dart';
import 'package:flutter_zth/screens/hero_screen.dart';
import 'package:flutter_zth/screens/mix_widget_screen.dart';
import 'package:flutter_zth/screens/safe_area_screen.dart';
import 'package:flutter_zth/screens/slider_screen.dart';
import 'package:flutter_zth/screens/snack_bar_screen.dart';
import 'package:flutter_zth/screens/splash_screen.dart';
import 'package:flutter_zth/screens/start/login_screen.dart';
import 'package:flutter_zth/screens/start/sign_up_screen.dart';
import 'package:flutter_zth/screens/text_field_screen.dart';
import 'package:go_router/go_router.dart';

class RouteItem {
  final String title;
  final String path;

  RouteItem({required this.title, required this.path});
}

final List<RouteItem> appRoutes = [
  RouteItem(title: 'Mix Widget', path: '/mix-widget-screen'),
  RouteItem(title: 'Drawer', path: '/drawer'),
  RouteItem(title: 'Safe Area', path: '/safe-area'),
  RouteItem(title: 'TextField', path: '/textfield'),
  RouteItem(title: 'Slider', path: '/slider'),
  RouteItem(title: 'Snack Bar', path: '/snack-bar'),
  RouteItem(title: 'Hero Example', path: '/hero'),
];

GoRouter goRoute = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(path: '/app', builder: (context, state) => const App()),
    ...appRoutes.map((routeItem) {
      Widget screenBuilder(BuildContext context, GoRouterState state) {
        switch (routeItem.path) {
          case '/mix-widget-screen':
            return const MixWidgetScreen();
          case '/drawer':
            return const DrawerScreen();
          case '/safe-area':
            return const SafeAreaScreen();
          case '/textfield':
            return const TextFieldScreen();
          case '/slider':
            return const SliderScreen();
          case '/snack-bar':
            return const SnackBarScreen();
          case '/hero':
            return const HeroScreen();
          default:
            return const Text('Halaman tidak dikenal');
        }
      }

      return GoRoute(path: routeItem.path, builder: screenBuilder);
    }).toList(),
  ],
  errorBuilder:
      (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')),
        body: Center(
          child: Text(
            'Maaf, halaman tidak ditemukan: ${state.error.toString()}',
          ),
        ),
      ),
);
