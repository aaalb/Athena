import 'package:frontend/Screens/Libretto/libretto_main.dart';
import 'package:frontend/Screens/Appelli/appelli_main.dart';
import 'package:frontend/Screens/Login/login_main.dart';
import 'package:frontend/Screens/Prenotazioni/prenotazioni_main.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'Login',
      path: '/',
      builder: (context, state) => Login(),
    ),
    GoRoute(
      name: 'Libretto',
      path: '/libretto',
      builder: (context, state) => Libretto(),
    ),
    GoRoute(
      name: 'Appelli',
      path: '/appelli',
      builder: (context, state) => Appelli(),
    ),
    GoRoute(
      name: 'Bacheca prenotazioni',
      path: '/prenotazioni',
      builder: (context, state) => Prenotazioni(),
    ),
    GoRoute(
      name: 'Logout',
      path: '/logout',
      builder: (context, state) => Prenotazioni(),
    ),
  ],
);
