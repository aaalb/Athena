import 'package:flutter/material.dart';
import 'package:frontend/Screens/Docente/EsamiDocente/components/esami_screen.dart';

import 'package:frontend/Screens/Docente/side_menu.dart';

class EsamiDocente extends StatefulWidget {
  const EsamiDocente({super.key});

  @override
  State<EsamiDocente> createState() => _LibrettoState();
}

class _LibrettoState extends State<EsamiDocente> {
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
              child: EsamiDocenteScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
