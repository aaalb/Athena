import 'package:flutter/material.dart';

import 'package:frontend/side_menu.dart';
import 'components/libretto_screen.dart';

class Libretto extends StatefulWidget {
  const Libretto({super.key});

  @override
  State<Libretto> createState() => _LibrettoState();
}

class _LibrettoState extends State<Libretto> {
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
              child: LibrettoScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
