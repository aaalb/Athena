import 'package:flutter/material.dart';
import 'white_box.dart';

GlobalKey<MyCanvasState> canvasKey =
    GlobalKey<MyCanvasState>(debugLabel: "canvasKey");

class MyCanvas extends StatefulWidget {
  final Widget child;
  const MyCanvas({super.key, required this.child});

  @override
  State<MyCanvas> createState() => MyCanvasState(child: child);
}

class MyCanvasState extends State<MyCanvas> {
  Widget child;

  MyCanvasState({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: canvasKey,
      body: Stack(
        key: GlobalKey(debugLabel: "stackKey"),
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/wallpaper.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          WhiteBox(child: child),
        ],
      ),
    );
  }
}
