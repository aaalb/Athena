import 'package:flutter/material.dart';
import 'package:frontend/Common/canvas.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/utils/AppService.dart';
import 'package:frontend/routes.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:frontend/user-data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserDataAdapter());
  await Hive.openBox('App Service Box');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AppService.instance.initialize();
    usePathUrlStrategy();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //GoRouter.optionURLReflectsImperativeAPIs = true;
    return MaterialApp.router(
        title: 'Athena',
        theme: ThemeData(
            fontFamily: 'Roboto',
            primaryColor: primaryColor,
            secondaryHeaderColor: secondaryColor,
            brightness: Brightness.light,
            primarySwatch:
                createMaterialColor(Color.fromARGB(255, 209, 67, 67)),
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
        //routerDelegate: router.routerDelegate,
        //routeInformationParser: router.routeInformationParser,
        //routeInformationProvider: router.routeInformationProvider,
        builder: (context, child) => MyCanvas(child: child!));
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
  return MaterialColor(color.value, swatch);
}
