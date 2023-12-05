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
      title: 'Athena',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: primaryColor,
        secondaryHeaderColor: secondaryColor,
        brightness: Brightness.light,
        primarySwatch: createMaterialColor(Color.fromARGB(255, 157, 98, 31)),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.blueGrey,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        dataTableTheme: const DataTableThemeData(
          dataTextStyle: TextStyle(fontFamily: 'Roboto', fontSize: 18),
          headingTextStyle: TextStyle(fontFamily: 'Roboto', fontSize: 23),
          headingRowHeight: 40,
          dividerThickness: 1, // Spessore del separatore tra le righe
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  ;
  return MaterialColor(color.value, swatch);
}
