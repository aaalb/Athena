import 'package:flutter/material.dart';

import 'package:frontend/Screens/Studente/side_menu.dart';
import 'components/prenotazioni_screen.dart';

class Prenotazioni extends StatefulWidget {
  const Prenotazioni({super.key});

  @override
  State<Prenotazioni> createState() => _PrenotazioniState();
}

class _PrenotazioniState extends State<Prenotazioni> {
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
              child: PrenotazioniScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
