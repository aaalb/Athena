import 'package:flutter/material.dart';
import 'package:frontend/Screens/Studente/Menu/menu_item.dart';
import 'package:go_router/go_router.dart';

class MenuComponent extends StatefulWidget {
  @override
  State<MenuComponent> createState() => MenuComponentState();
}

class MenuComponentState extends State<MenuComponent> {
  @override
  Widget build(BuildContext context) {
    return Column
    (
      children: 
      [
        Text("Ciao, Albert", style: TextStyle
        (
          color: Color.fromARGB(255, 209, 67, 67),
          fontFamily: 'SourceSansPro',
          fontWeight: FontWeight.w600,
          fontSize: 44,
        ),),
        Divider(height: 20,),
        Row
        (
          children: 
          [
            VerticalDivider(width: 30,),
            Expanded
            (
              child: MenuItem(imagePath: "images/libretto_icon_2.png", label: "Libretto",
                onClick: () => GoRouter.of(context).go("/studente/libretto"),
              ),
            ),
            VerticalDivider(width: 30,),
            Expanded
            (
              child: MenuItem(imagePath: "images/iscrizione_icon_2.png", label: "Appelli",
                onClick: () => GoRouter.of(context).go("/studente/appelli"),
              )
            ),
            VerticalDivider(width: 30,),
            Expanded
            (
              child: MenuItem(imagePath: "images/bacheca_icon_2.png", label: "Prenotazioni")
            ),
            VerticalDivider(width: 30,),
            
          ],
        ),
        Divider(height: 30,),
      ],
    );
  }
}

