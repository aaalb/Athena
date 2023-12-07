import 'package:flutter/material.dart';
import 'package:frontend/utils/AppService.dart';
import 'package:frontend/utils/AuthService.dart';
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
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: Icon(Icons.logout_rounded),
                color: Colors.red,
                onPressed: () {
                  AuthService.logout();
                  AppService.instance.manageAutoLogout();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
