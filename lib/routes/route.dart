// lib/routes/route.dart
// ignore_for_file: unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:flutter_zth/app.dart';
import 'package:flutter_zth/home.dart';
import 'package:flutter_zth/screens/drawer_screen.dart';
import 'package:flutter_zth/screens/hero_screen.dart';
import 'package:flutter_zth/screens/mix_widget_screen.dart';
import 'package:flutter_zth/screens/page_view_screen.dart';
import 'package:flutter_zth/screens/pagination_screen.dart';
import 'package:flutter_zth/screens/crud.dart';
import 'package:flutter_zth/screens/refresh_indicator_screen.dart';
import 'package:flutter_zth/screens/safe_area_screen.dart';
import 'package:flutter_zth/screens/search_bar_screen.dart';
import 'package:flutter_zth/screens/slider_screen.dart';
import 'package:flutter_zth/screens/sliver_app_bar_screen.dart';
import 'package:flutter_zth/screens/snack_bar_screen.dart';
import 'package:flutter_zth/screens/todo_screen.dart';
import 'package:flutter_zth/widgets/splash_screen.dart';
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
  RouteItem(title: 'Page View', path: '/page-view'),
  RouteItem(title: 'Sliver App Bar', path: '/sliver-app-bar'),
  RouteItem(title: 'To Do', path: '/todo'),
  RouteItem(title: 'CRUD', path: '/crud'),
  RouteItem(title: 'Refresh Indicator', path: '/refresh'),
  RouteItem(title: 'Seacrh Bar', path: '/seach-bar'),
  RouteItem(title: 'Pagination and Sorting', path: '/pagination'),
];

GoRouter goRoute = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(path: '/app', builder: (context, state) => const App()),
    GoRoute(path: '/home', builder: (context, state) => const Home()),
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
          case '/refresh':
            return const RefreshIndicatorScreen();
          case '/seach-bar':
            return const SearchBarScreen();
          case '/page-view':
            return PageViewScreen();
          case '/sliver-app-bar':
            return SliverAppBarScreen();
          case '/crud':
            return Crud();
          case '/pagination':
            return PaginationScreen();
          case '/todo':
            return TodoScreen();
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
