import 'package:flutter/material.dart';
import 'package:frontend/Screens/Libretto/libretto_main.dart';
import 'package:frontend/Screens/Appelli/appelli_main.dart';
import 'package:frontend/Screens/Login/login_main.dart';
import 'package:frontend/Screens/Prenotazioni/prenotazioni_main.dart';
import 'package:frontend/Screens/Dashboard/dashboard_main.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'Profilo',
      path: '/profilo',
      builder: (context, state) => Dashboard(),
    ),
    GoRoute(
      name: 'Dashboard',
      path: '/',
      builder: (context, state) => Dashboard(),
    ),
    GoRoute(
      name: 'Login',
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
        name: 'Libretto',
        path: '/libretto',
        builder: (context, state) => Libretto(),
        redirect: (context, state) => _redirect(context, state)),
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

String? _redirect(BuildContext context, GoRouterState state) {
  bool isAuthenticated = true;
  return isAuthenticated ? null : state.namedLocation("Login");
}
