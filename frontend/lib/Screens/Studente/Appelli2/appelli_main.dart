import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/Common/notifications.dart';
import 'package:frontend/Common/page_dimensions.dart';
import 'package:frontend/Screens/Studente/models/appello_tile.dart';

import './appelli_screen.dart';

class Appelli2 extends StatefulWidget {
  const Appelli2({super.key});

  static PageDimensions dimensions = const PageDimensions
  (
    //width: 800,
    constraints: BoxConstraints
    (
      minWidth: 390,
      maxWidth: 600,
      minHeight: 200,
      maxHeight: 400,
    )
  );

  @override
  State<Appelli2> createState() => Appelli2State();
}

class Appelli2State extends State<Appelli2> {
  
  void initState()
  {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp)
    {
      LoadNewPageNotification
      (
        width: Appelli2.dimensions.width,
        height: Appelli2.dimensions.height,
        constraints: Appelli2.dimensions.constraints,
      ).dispatch(context);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding
    (
      padding: EdgeInsets.all(20),
      child: Center(child: Appelli2Component(key: ConfermaAppelloTileState.appelliKey,)),
    );


    /*return const Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: SideMenu(),
            ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: LibrettoScreen(),
            ),
          ],
        ),
      ),
    );*/
  }
}
