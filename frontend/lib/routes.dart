import 'package:frontend/Screens/Libretto/libretto_main.dart';
import 'package:frontend/Screens/Appelli/appelli_main.dart';
import 'package:frontend/Screens/Login/login_main.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name:
          'login', // Optional, add name to your routes. Allows you navigate by name instead of path
      path: '/',
      builder: (context, state) => Login(),
    ),
    GoRoute(
      name: 'libretto',
      path: '/libretto',
      builder: (context, state) => Libretto(),
    ),
    GoRoute(
      name: 'appelli',
      path: '/appelli',
      builder: (context, state) => Appelli(),
    ),
  ],
);
