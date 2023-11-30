import 'package:flutter/material.dart';
import 'package:frontend/Screens/Libretto/libretto_main.dart';
import 'dart:js';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("images/cf-logo.png"),
          ),
          DrawerListTile(
            title: "Libretto",
            svgSrc: "images/libretto_icon.png",
            press: () => context.go('/libretto'),
          ),
          DrawerListTile(
            title: "Iscrizione agli appelli",
            svgSrc: "images/iscrizione_icon.png",
            press: () => context.go('/appelli'),
          ),
          DrawerListTile(
            title: "Bacheca prenotazioni",
            svgSrc: "images/bacheca_icon.png",
            press: () => context.go('/prenotazioni'),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Image.asset(
        svgSrc,
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Color.fromARGB(137, 0, 0, 0)),
      ),
    );
  }
}
