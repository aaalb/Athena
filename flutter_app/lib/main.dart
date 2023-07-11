import 'package:flutter/material.dart';
import 'package:flutter_app/loginPage.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

import 'dashboard.dart';
import 'libretto.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => DashBoard(title: 'ciao'),
    ),
    GoRoute(
      path: "/libretto",
      builder: (context, state) => Libretto(),
    ),
    GoRoute(
      path: "/login",
      builder: (context, state) => LoginPage(),
    ),
  ],
);

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: "BD2 - Progetto",
      theme: ThemeData.light(useMaterial3: true),
    );
  }
}
