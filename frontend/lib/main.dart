import 'package:flutter/material.dart';
import 'package:frontend/Common/canvas.dart';
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
            filled: false,
            border: OutlineInputBorder(
              //borderSide: BorderSide.none,
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
      builder: (context, child) => MyCanvas(child: child!)
    );
  }
}

MaterialColor createMaterialColor(Color color) 
{
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) 
  {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths)
  {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}