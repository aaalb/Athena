import 'package:flutter/material.dart';
import 'package:flutter_app/screens/appelli/appelli_screen.dart';

import 'package:flutter_app/side_menu.dart';

class AppelliMain extends StatefulWidget {
  const AppelliMain({super.key});

  @override
  State<AppelliMain> createState() => _AppelliState();
}

class _AppelliState extends State<AppelliMain> {
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
              child: Appelli(),
            ),
          ],
        ),
      ),
    );
  }
}
