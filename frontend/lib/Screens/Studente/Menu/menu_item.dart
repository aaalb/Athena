import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuItem extends StatefulWidget {
  final String? imagePath;
  final String? label;
  const MenuItem({this.imagePath, this.label});

  @override
  State<MenuItem> createState() =>
      MenuItemState(imagePath: imagePath, label: label);
}

class MenuItemState extends State<MenuItem> {
  String? imagePath;
  String? label;
  double elevation = 2;
  MenuItemState({this.imagePath, this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
      onTap: () {
        context.go('/$label'.toLowerCase());
      },
      onHover: (val) => setState(() {
        elevation = val ? 20 : 2;
      }),
    );
  }
}
