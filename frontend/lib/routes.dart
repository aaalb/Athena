import 'package:flutter/material.dart';
import 'package:frontend/Screens/Login/login_main.dart';
import 'package:frontend/Screens/Studente/Appelli/appelli_main.dart';
import 'package:frontend/Screens/Studente/Dashboard/dashboard_main.dart';
import 'package:frontend/Screens/Studente/Libretto/libretto_main.dart';
import 'package:frontend/Screens/Studente/Prenotazioni/prenotazioni_main.dart';
import 'package:frontend/models/AuthService.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'Profilo',
      path: '/profilo',
      builder: (context, state) => Dashboard(),
      redirect: (context, state) => _redirect(context, state),
    ),
    GoRoute(
      name: 'Dashboard',
      path: '/',
      builder: (context, state) => Dashboard(),
      //redirect: (context, state) => _redirect(context, state),
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
      redirect: (context, state) => _redirect(context, state),
    ),
    GoRoute(
      name: 'Appelli',
      path: '/appelli',
      builder: (context, state) => Appelli(),
      redirect: (context, state) => _redirect(context, state),
    ),
    GoRoute(
      name: 'Bacheca prenotazioni',
      path: '/prenotazioni',
      builder: (context, state) => Prenotazioni(),
      redirect: (context, state) => _redirect(context, state),
    ),
    GoRoute(
      name: 'Logout',
      path: '/logout',
      builder: (context, state) => Prenotazioni(),
      redirect: (context, state) => _redirect(context, state),
    ),
  ],
);

String? _redirect(BuildContext context, GoRouterState state) {
  return (AuthService.isAuthenticated) ? null : null;
}
