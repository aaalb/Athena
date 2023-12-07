import 'package:flutter/material.dart';
import 'package:frontend/Screens/Studente/Menu/menu_item.dart';
import 'package:frontend/utils/AppService.dart';
import 'package:go_router/go_router.dart';

class MenuComponent extends StatefulWidget {
  @override
  State<MenuComponent> createState() => MenuComponentState();
}

class MenuComponentState extends State<MenuComponent> {
  String nome = AppService.instance.currentUser?.nome ?? "Error 404";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Ciao, $nome",
          style: const TextStyle(
            color: Color.fromARGB(255, 209, 67, 67),
            fontFamily: 'SourceSansPro',
            fontWeight: FontWeight.w600,
            fontSize: 44,
          ),
        ),
        const Divider(
          height: 20,
        ),
        Row(
          children: [
            const VerticalDivider(
              width: 30,
            ),
            Expanded(
              child: MenuItem(
                imagePath: "images/libretto_icon_2.png",
                label: "Libretto",
                onClick: () => GoRouter.of(context).go("/studente/libretto"),
              ),
            ),
            const VerticalDivider(
              width: 30,
            ),
            const Expanded(
                child: MenuItem(
                    imagePath: "images/iscrizione_icon_2.png",
                    label: "Appelli")),
            const VerticalDivider(
              width: 30,
            ),
            Expanded(
              child: MenuItem(
                imagePath: "images/bacheca_icon_2.png",
                label: "Prenotazioni",
                onClick: () =>
                    GoRouter.of(context).go("/studente/prenotazioni"),
              ),
            ),
            const VerticalDivider(
              width: 30,
            ),
          ],
        ),
        const Divider(
          height: 30,
        ),
      ],
    );
  }
}
