import 'package:flutter/material.dart';
import 'package:frontend/Screens/Docente/AppelliDocente/appelli_main.dart';
import 'package:frontend/Screens/Docente/EsamiDocente/esami_main.dart';
import 'package:frontend/Screens/Studente/Appelli/appelli_main.dart';
import 'package:frontend/Screens/Studente/Appelli2/appelli_main.dart';
import 'package:frontend/Screens/Studente/Libretto/libretto_main.dart';
import 'package:frontend/Screens/Studente/Menu/menu_main.dart';
import 'package:frontend/Screens/Docente/Menu/menu_main.dart';
import 'package:frontend/Screens/Login/login_main.dart';
import 'package:frontend/Screens/Studente/Prenotazioni/prenotazioni_main.dart';
import 'package:frontend/utils/AppService.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: (AppService.instance.currentUser?.role == 'Studente')
      ? '/studente'
      : '/docente',
  redirect: _redirect,
  debugLogDiagnostics: true,
  refreshListenable: AppService.instance,
  navigatorKey: AppService.instance.navigatorKey,
  routes: <GoRoute>[
    GoRoute(
      name: 'Login',
      path: '/login',
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
            maintainState: false,
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
      routes: [
        GoRoute(
          name: 'LibrettoStudente',
          path: 'libretto',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                //maintainState: false,
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
        ),
        GoRoute(
          name: 'AppelliStudente',
          path: 'appelli',
          pageBuilder: (context, state) => CustomTransitionPage(
              //maintainState: false,
              transitionDuration: const Duration(milliseconds: 200),
              key: state.pageKey,
              child: Appelli2(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(
                        opacity: animation,
                        child: child,
                      )),
        ),
        GoRoute(
          name: 'PrenotazioniStudente',
          path: 'prenotazioni',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
                //maintainState: false,
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
      ],
    ),
    GoRoute(
        name: "MenuDocente",
        path: '/docente',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
              maintainState: false,
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
        routes: [
          GoRoute(
            name: 'EsamiDocente',
            path: 'esami',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                  //maintainState: false,
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
            path: 'appelli',
            pageBuilder: (context, state) => CustomTransitionPage(
                //maintainState: false,
                transitionDuration: const Duration(milliseconds: 200),
                key: state.pageKey,
                child: AppelliDocente(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(
                          opacity: animation,
                          child: child,
                        )),
          ),
        ]),
  ],
);

String? _redirect(BuildContext context, GoRouterState state) {
  final isLoggedIn = AppService.instance.isLoggedIn;
  final isLoginRoute = state.matchedLocation == LoginPage.route;
  final String userRole = AppService.instance.currentUser?.role ?? "Null";

  if (!isLoggedIn && !isLoginRoute) {
    return LoginPage.route;
  }

  if (state.matchedLocation.startsWith(MenuDocente.route) &&
      userRole != 'Docente') {
    return LoginPage.route; // Reindirizza a un'altra pagina.
  }
  if (state.matchedLocation.startsWith(MenuStudente.route) &&
      userRole != 'Studente') {
    return LoginPage.route; // Reindirizza a un'altra pagina.
  }

  return null;
}
