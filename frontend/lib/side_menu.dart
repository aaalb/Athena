import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("images/logo.jpeg"),
          ),
          DrawerListTile(
            title: "Libretto",
            svgSrc: "icons/libretto.svg",
            press: () => context.go('/libretto'),
          ),
          DrawerListTile(
            title: "Iscrizione agli appelli",
            svgSrc: "icons/libretto.svg",
            press: () => context.go('/appelli'),
          ),
          DrawerListTile(
            title: "Bacheca prenotazioni",
            svgSrc: "icons/libretto.svg",
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
      leading: SvgPicture.asset(
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
