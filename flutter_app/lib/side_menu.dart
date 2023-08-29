import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("images/logo.jpg"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "icons/menu_dashboard.svg",
            press: () => context.go('/'),
          ),
          DrawerListTile(
            title: "Libretto",
            svgSrc: "icons/menu_dashboard.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Prenotazione Appelli",
            svgSrc: "icons/menu_tran.svg",
            press: () => context.go('/appelli'),
          ),
          DrawerListTile(
            title: "Le mie prenotazioni",
            svgSrc: "icons/menu_doc.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
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
        colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
