import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:frontend/routes.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BD2 - Progetto',
      theme: ThemeData(
          fontFamily: 'Roboto',
          primaryColor: primaryColor,
          secondaryHeaderColor: secondaryColor,
          brightness: Brightness.light,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            fillColor: secondaryColor,
            prefixIconColor: Colors.purple,
            hintStyle: const TextStyle(fontFamily: 'Roboto'),
          ),
          dataTableTheme: const DataTableThemeData(
            dataTextStyle: TextStyle(fontFamily: 'Roboto'),
            headingTextStyle: TextStyle(fontFamily: 'Roboto', fontSize: 18),
          )),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
