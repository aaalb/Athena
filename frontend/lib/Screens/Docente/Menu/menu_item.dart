import 'package:flutter/material.dart';

class MenuItem extends StatefulWidget {
  final String? imagePath;
  final String? label;
  final Function()? onClick;
  const MenuItem({this.imagePath, this.label, this.onClick});

  @override
  State<MenuItem> createState() =>
      MenuItemState(imagePath: imagePath, label: label, onClick: onClick);
}

class MenuItemState extends State<MenuItem> {
  String? imagePath;
  String? label;
  Function()? onClick;
  double elevation = 2;
  MenuItemState({this.imagePath, this.label, this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: IgnorePointer(
        child: Material(
          elevation: elevation,
          child: Column(children: [
            Image.asset(
              imagePath!,
              width: 100,
              height: 100,
              //color: Color.fromARGB(255, 209, 67, 67),
            ),
            Text(label!),
          ]),
        ),
      ),
      onTap: onClick,
      onHover: (val) => setState(() {
        elevation = val ? 20 : 2;
      }),
    );
  }
}
