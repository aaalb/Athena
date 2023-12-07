import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/Screens/Docente/Menu/menu.dart';
import 'package:frontend/Common/page_dimensions.dart';
import 'package:frontend/Common/notifications.dart';

class MenuDocente extends StatefulWidget {
  static const route = '/docente';
  const MenuDocente({super.key});

  static PageDimensions dimensions = const PageDimensions(
      width: 800,
      height: 230,
      constraints: BoxConstraints(
        minWidth: 390,
        maxWidth: 700,
        maxHeight: 265,
        minHeight: 265,
      ));

  @override
  State<MenuDocente> createState() => MenuState();
}

class MenuState extends State<MenuDocente> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      LoadNewPageNotification(
        width: MenuDocente.dimensions.width,
        height: MenuDocente.dimensions.height,
        constraints: MenuDocente.dimensions.constraints,
      ).dispatch(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(child: MenuComponent()),
    );
  }
}
