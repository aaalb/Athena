import 'package:flutter/material.dart';
import 'package:frontend/Screens/Docente/AppelliDocente/components/appelli_screen.dart';
import 'package:frontend/Screens/Docente/side_menu.dart';

class AppelliDocente extends StatefulWidget {
  const AppelliDocente({super.key});

  @override
  State<AppelliDocente> createState() => _LibrettoState();
}

class _LibrettoState extends State<AppelliDocente> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: SideMenu(),
            ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: AppelliDocenteScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
