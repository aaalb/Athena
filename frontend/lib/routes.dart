import 'package:frontend/Screens/Libretto/libretto_screen.dart';
import 'package:frontend/Screens/Login/login_screen.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name:
          'login', // Optional, add name to your routes. Allows you navigate by name instead of path
      path: '/',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      name: 'libretto',
      path: '/libretto',
      builder: (context, state) => LibrettoScreen(),
    ),
  ],
);
