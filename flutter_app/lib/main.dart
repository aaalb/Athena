import 'package:flutter_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/appelli/appelli_main.dart';
import 'package:flutter_app/screens/dashboard/dashboard_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name:
          'dashboard', // Optional, add name to your routes. Allows you navigate by name instead of path
      path: '/',
      builder: (context, state) => DashboardMain(),
    ),
    GoRoute(
      name: 'appelli',
      path: '/appelli',
      builder: (context, state) => AppelliMain(),
    ),
  ],
);
