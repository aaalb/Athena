import 'package:flutter/material.dart';
import 'package:frontend/Screens/Docente/AppelliDocente/appelli_main.dart';
import 'package:frontend/Screens/Studente/Libretto/libretto_main.dart';
import 'package:frontend/Screens/Studente/Menu/menu_main.dart';
import 'package:frontend/Screens/Docente/Menu/menu_main.dart';
import 'package:frontend/Screens/Studente/Prenotazioni/prenotazioni_main.dart';
import 'package:frontend/Screens/Login/login_main.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/utils/AuthService.dart';
import 'package:frontend/Screens/Docente/EsamiDocente/esami_main.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'Login',
      path: '/',
      pageBuilder: (context, state) => CustomTransitionPage(
        transitionDuration: const Duration(milliseconds: 200),
        key: state.pageKey,
        child: LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    ),
    GoRoute(
      name: "MenuStudente",
      path: '/studente',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 200),
            key: state.pageKey,
            child: MenuStudente(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
                      opacity: animation,
                      child: child,
                    ));
      },
    ),
    GoRoute(
      name: "MenuDocente",
      path: '/docente',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 200),
            key: state.pageKey,
            child: MenuDocente(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
                      opacity: animation,
                      child: child,
                    ));
      },
    ),
    GoRoute(
      name: 'Libretto',
      path: '/libretto',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 200),
            key: state.pageKey,
            child: Libretto2(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
                      opacity: animation,
                      child: child,
                    ));
      },
      redirect: (context, state) => _redirect(context, state),
    ),
    /*GoRoute(
      name: 'Appelli',
      path: '/appelli',
      builder: (context, state) => Appelli2(),
      redirect: (context, state) => _redirect(context, state),
    ),*/
    GoRoute(
      name: "Prenotazioni",
      path: '/studente/prenotazioni',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 200),
            key: state.pageKey,
            child: Prenotazioni(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
                      opacity: animation,
                      child: child,
                    ));
      },
    ),
    GoRoute(
      name: 'Logout',
      path: '/logout',
      builder: (context, state) => Prenotazioni(),
      redirect: (context, state) => _redirect(context, state),
    ),
    GoRoute(
      name: 'EsamiDocente',
      path: '/docente/esami',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 200),
            key: state.pageKey,
            child: EsamiDocente(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
                      opacity: animation,
                      child: child,
                    ));
      },
    ),
    GoRoute(
      name: 'AppelliDocente',
      path: '/docente/appelli',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 200),
            key: state.pageKey,
            child: AppelliDocente(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
                      opacity: animation,
                      child: child,
                    ));
      },
    ),
  ],
);

String? _redirect(BuildContext context, GoRouterState state) {
  return (AuthService.isAuthenticated) ? null : null;
}
